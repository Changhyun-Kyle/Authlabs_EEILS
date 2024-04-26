//
//  ARViewController.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/22/24.
//

import ARKit
import SceneKit
import UIKit

final class ARViewController: UIViewController {
  private let arManager: ARManager = .init()
  private let sceneView: ARSCNView = .init()
  private let blurView: UIVisualEffectView = .init()
  private var referenceImage: ARReferenceImage?
  private var imageAnchor: ARImageAnchor?
  private var session: ARSession {
    return sceneView.session
  }
  private var imageHighlightAction: SCNAction {
    return .sequence(
      [
        .wait(duration: 0.25),
        .fadeOpacity(to: 0.55, duration: 0.25),
        .fadeOpacity(to: 0.15, duration: 0.25),
        .fadeOpacity(to: 0.55, duration: 0.25),
        .fadeOpacity(to: 0.30, duration: 0.25),
      ]
    )
  }
  private lazy var statusViewController: StatusViewController = {
    return children.lazy.compactMap { $0 as? StatusViewController }.first!
  }()
  private var isRestartAvailable = true
  
  override func loadView() {
    sceneView.delegate = self
    sceneView.session.delegate = self
    statusViewController.restartExperienceHandler = { [weak self] in
        self?.restartExperience()
    }
    view = sceneView
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIApplication.shared.isIdleTimerDisabled = true
    addTapGesture()
    resetTracking()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    session.pause()
  }
}

private extension ARViewController {
  func addTapGesture() {
    let tapGestureRecognizer = UITapGestureRecognizer(
      target : self,
      action : #selector(tappedTrackingImage)
    )
    self.sceneView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc
  func tappedTrackingImage(recognizer: UITapGestureRecognizer){
    guard
      let sceneView = recognizer.view as? SCNView
    else {
      return
    }
    
    let touchLocation : CGPoint = recognizer.location(in: sceneView)
    let hitResults : [SCNHitTestResult] = sceneView.hitTest(touchLocation, options: [:])
    
    guard
      !hitResults.isEmpty,
      let referenceImage = self.referenceImage,
      let imageName = referenceImage.name,
      let capturedImage = self.sceneView.captureImage(by: hitResults[0].node),
      let originalImage = UIImage(named: imageName),
      let imageURL = capturedImage.pngData()?.base64EncodedString()
    else {
      return
    }
    
    self.fetchResponse(
      imageURL: imageURL,
      capturedImage: capturedImage,
      originalImage: originalImage
    )
  }
  
  func resetTracking() {
    guard
      let referenceImages = ARReferenceImage.referenceImages(
        inGroupNamed: "AR Resources",
        bundle: nil
      )
    else {
      return
    }
    
    let configuration = ARImageTrackingConfiguration()
    configuration.trackingImages = referenceImages
    
    session.run(
      configuration,
      options: [
        .resetTracking,
        .removeExistingAnchors
      ]
    )
    statusViewController.scheduleMessage(
      "이미지를 감지하기 위해 카메라를 움직여보세요",
      inSeconds: 7.5,
      messageType: .contentPlacement
    )
  }
  
  func fetchResponse(
    imageURL: String,
    capturedImage: UIImage,
    originalImage: UIImage
  ) {
    Task {
      do {
        LoadingIndicatorView.showLoading(in: self.view)
        session.pause()
        let result = try await arManager.fetchResponse(imageURL: imageURL)
        DispatchQueue.main.async {
          self.presentDetailViewController(
            with: result.content,
            captureImage: capturedImage,
            originalImage: originalImage
          )
        }
      } catch {
        // TODO: - Alert
        print(error.localizedDescription)
      }
    }
  }
  
  func presentDetailViewController(
    with result: String,
    captureImage: UIImage,
    originalImage: UIImage
  ) {
    let detailViewController = DetailViewController()
    let content = result.formatResponse()
    detailViewController.configure(
      definition: content.definition,
      description: content.description,
      captureImage: captureImage,
      originalImage: originalImage
    )
    self.present(detailViewController, animated: true) {
      LoadingIndicatorView.hideLoading(in: self.view)
    }
    resetTracking()
  }
}

extension ARViewController: ARSCNViewDelegate {
  func renderer(
    _ renderer: any SCNSceneRenderer,
    didAdd node: SCNNode,
    for anchor: ARAnchor
  ) {
    guard let imageAnchor = anchor as? ARImageAnchor else { return }
    self.imageAnchor = imageAnchor
    let referenceImage = imageAnchor.referenceImage
    self.referenceImage = referenceImage
    DispatchQueue.global().async {
      let plane = SCNPlane(
        width: referenceImage.physicalSize.width,
        height: referenceImage.physicalSize.height
      )
      let planeNode = SCNNode(geometry: plane)
      planeNode.eulerAngles.x = -.pi / 2
      planeNode.runAction(self.imageHighlightAction)
      node.addChildNode(planeNode)
    }
    
    DispatchQueue.main.async {
      let imageName = referenceImage.name ?? ""
      self.statusViewController.cancelAllScheduledMessages()
      self.statusViewController.showMessage("감지된 이미지 - “\(imageName)”")
    }
  }
}

extension ARViewController: ARSessionDelegate {
  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    statusViewController.showTrackingQualityInfo(for: camera.trackingState, autoHide: true)
    switch camera.trackingState {
    case .notAvailable, .limited:
      statusViewController.escalateFeedback(for: camera.trackingState, inSeconds: 3.0)
    case .normal:
      statusViewController.cancelScheduledMessage(for: .trackingStateEscalation)
    }
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
      guard error is ARError else { return }
      
      let errorWithInfo = error as NSError
      let messages = [
          errorWithInfo.localizedDescription,
          errorWithInfo.localizedFailureReason,
          errorWithInfo.localizedRecoverySuggestion
      ]
      
      // Use `flatMap(_:)` to remove optional error messages.
      let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
      
      DispatchQueue.main.async {
          self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
      }
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
      blurView.isHidden = false
      statusViewController.showMessage("""
      SESSION INTERRUPTED
      The session will be reset after the interruption has ended.
      """, autoHide: false)
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
      blurView.isHidden = true
      statusViewController.showMessage("RESETTING SESSION")
      
      restartExperience()
  }
  
  func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
      return true
  }
  
  // MARK: - Error handling
  
  func displayErrorMessage(title: String, message: String) {
      // Blur the background.
      blurView.isHidden = false
      
      // Present an alert informing about the error that has occurred.
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
          alertController.dismiss(animated: true, completion: nil)
          self.blurView.isHidden = true
          self.resetTracking()
      }
      alertController.addAction(restartAction)
      present(alertController, animated: true, completion: nil)
  }

  // MARK: - Interface Actions
  
  func restartExperience() {
      guard isRestartAvailable else { return }
      isRestartAvailable = false
      
      statusViewController.cancelAllScheduledMessages()
      
      resetTracking()
      
      // Disable restart for a while in order to give the session time to restart.
      DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
          self.isRestartAvailable = true
      }
  }
  
}
