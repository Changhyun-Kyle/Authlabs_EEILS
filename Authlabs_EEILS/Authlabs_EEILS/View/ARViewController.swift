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
  
  override func loadView() {
    sceneView.delegate = self
    view = sceneView
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIApplication.shared.isIdleTimerDisabled = true
    addTapGesture()
    startTracking()
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
  
  func startTracking() {
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
  }
  
  func fetchResponse(
    imageURL: String,
    capturedImage: UIImage,
    originalImage: UIImage
  ) {
    Task {
      do {
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
    with imageName: String,
    captureImage: UIImage,
    originalImage: UIImage
  ) {
    let detailViewController = DetailViewController()
    detailViewController.configure(
      name: imageName,
      captureImage: captureImage,
      originalImage: originalImage
    )
    self.present(detailViewController, animated: true)
    startTracking()
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
  }
}
