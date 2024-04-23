//
//  ARSCNView+.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/23/24.
//

import ARKit

extension ARSCNView {
  func captureImage(by node: SCNNode) -> UIImage? {
    hideAllNodes()
    let snapshot = self.snapshot()
    showAllNodes()
    let rect = resizeTrackingImage(of: node)
    return snapshot.crop(to: rect)
  }
  
  private func hideAllNodes() {
    let allNodes = self.scene.rootNode.childNodes
    _ = allNodes.map { $0.isHidden = true }
  }
  
  private func showAllNodes() {
    let allNodes = self.scene.rootNode.childNodes
    _ = allNodes.map { $0.isHidden = false }
  }
  
  private func resizeTrackingImage(of node: SCNNode) -> CGRect {
    let scale = UIScreen.main.scale
    let (min, max) = node.boundingBox
    
    let minVector = SCNVector3(
      min.x,
      min.y,
      min.z
    )
    let maxVector = SCNVector3(
      max.x,
      max.y,
      max.z
    )
    
    let minScreenPoint = self.projectPoint(node.convertPosition(minVector, to: nil))
    let maxScreenPoint = self.projectPoint(node.convertPosition(maxVector, to: nil))
    
    let x = CGFloat(minScreenPoint.x) * scale
    let y = CGFloat(minScreenPoint.y) * scale
    let width = CGFloat(maxScreenPoint.x - minScreenPoint.x) * scale
    let height = CGFloat(maxScreenPoint.y - minScreenPoint.y) * scale
    
    return CGRect(
      x: x,
      y: y,
      width: width,
      height: height
    )
  }
}
