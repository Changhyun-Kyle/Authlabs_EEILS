//
//  DetailViewController.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/22/24.
//

import UIKit

final class DetailViewController: UIViewController {
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "분석결과"
    label.textAlignment = .left
    label.textColor = .black
    label.font = .preferredFont(forTextStyle: .largeTitle)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
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
  
  private lazy var imageStackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews:
        [
          originalImageView,
          captureImageView
        ]
    )
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 5
    stackView.alignment = .center
    stackView.alignment = .top
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override func loadView() {
    super.loadView()
    configureUI()
    setupConstraints()
  }
  
  func configure(
    name: String,
    captureImage: UIImage,
    originalImage: UIImage
  ) {
    self.nameLabel.text = name
    self.captureImageView.image = captureImage
    self.originalImageView.image = originalImage
  }
}

private extension DetailViewController {
  func configureUI() {
    view.addSubview(nameLabel)
    view.addSubview(imageStackView)
    view.addSubview(titleLabel)
    view.backgroundColor = .white
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate(
      [
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
        nameLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
        nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
        nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        imageStackView.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10),
        imageStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
        imageStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        imageStackView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height * 0.3),
      ]
    )
  }
}
