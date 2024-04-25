//
//  ContentImageStackView.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/25/24.
//

import UIKit

final class ContentImageStackView: UIStackView {
  private var captureImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private var originalImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private var captureImageLabel: UILabel = {
    let label = UILabel()
    label.text = "캡처(트래킹) 이미지"
    label.textColor = .black
    return label
  }()
  
  private var originalImageLabel: UILabel = {
    let label = UILabel()
    label.text = "원본 이미지"
    label.textColor = .black
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(captureImage: UIImage, originalImage: UIImage) {
    self.captureImageView.image = captureImage
    self.originalImageView.image = originalImage
  }
}

private extension ContentImageStackView {
  func configureUI() {
    self.axis = .horizontal
    self.distribution = .fillEqually
    self.spacing = 5
    self.alignment = .center
    self.addArrangedSubview(originalImageView)
    self.addArrangedSubview(captureImageView)
  }
}
