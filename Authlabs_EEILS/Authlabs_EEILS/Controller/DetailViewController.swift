//
//  DetailViewController.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/22/24.
//

import UIKit

final class DetailViewController: UIViewController {
  private let detailView = DetailView()
  
  override func loadView() {
    super.loadView()
    view = detailView
  }
  
  func configure(
    definition: String,
    description: String,
    captureImage: UIImage,
    originalImage: UIImage
  ) {
    detailView.configure(
      definition: definition,
      description: description,
      captureImage: captureImage,
      originalImage: originalImage
    )
  }
}
