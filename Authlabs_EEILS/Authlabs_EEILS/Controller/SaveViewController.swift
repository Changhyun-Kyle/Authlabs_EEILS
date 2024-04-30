//
//  SaveViewController.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/29/24.
//

import UIKit

final class SaveViewController: UIViewController {
  override func loadView() {
    super.loadView()
    configureUI()
  }
}

private extension SaveViewController {
  func configureUI() {
    self.title = "저장목록"
  }
  
  func 나는_왜_사는걸까() {
    self.dismiss(animated: false)
  }
}
