//
//  ViewController.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/22/24.
//

import ARKit
import SceneKit
import UIKit

final class ViewController: UIViewController {
  
  private let sceneView: ARSCNView = .init()
  private let blurView: UIVisualEffectView = .init()
  private var session: ARSession {
    return sceneView.session
  }
  private var imageHighlightAction: SCNAction {
    return .sequence(
      [
        .wait(duration: 0.25),
        .fadeOpacity(to: 0.85, duration: 0.25),
        .fadeOpacity(to: 0.15, duration: 0.25),
        .fadeOpacity(to: 0.85, duration: 0.25),
        .fadeOut(duration: 0.5),
        .removeFromParentNode()
      ]
    )
  }
  override func loadView() {
    sceneView.delegate = self
    sceneView.session.delegate = self
    view = sceneView
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIApplication.shared.isIdleTimerDisabled = true
    startTracking()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    session.pause()
  }
}

private extension ViewController {
  func startTracking() {
    guard
      let referenceImages = ARReferenceImage.referenceImages(
        inGroupNamed: "AR Resources",
        bundle: nil
      )
    else {
      return
    }
    let configuration = ARWorldTrackingConfiguration()
    configuration.detectionImages = referenceImages
    session.run(
      configuration,
      options: [
        .resetTracking,
        .removeExistingAnchors
      ]
    )
  }
  
  func presentDetailViewController() {
    
  }
}

extension ViewController: ARSCNViewDelegate {
  func renderer(
    _ renderer: any SCNSceneRenderer,
    didAdd node: SCNNode,
    for anchor: ARAnchor
  ) {
    guard let imageAnchor = anchor as? ARImageAnchor else { return }
    let referenceImage = imageAnchor.referenceImage
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
      guard let imageName = referenceImage.name else { return }
      let detailViewController = DetailViewController()
      detailViewController.setupNameLabel(name: imageName)
      self.present(detailViewController, animated: true)
    }
  }
}

extension ViewController: ARSessionDelegate { }

