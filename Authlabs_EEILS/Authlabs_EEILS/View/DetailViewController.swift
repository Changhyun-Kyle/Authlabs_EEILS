//
//  DetailViewController.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/22/24.
//

import UIKit

final class DetailViewController: UIViewController {
  private var nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.text = "test"
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
    view.backgroundColor = .white
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate(
      [
        nameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
        nameLabel.heightAnchor.constraint(equalToConstant: 50),
        nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
        nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        imageStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
        imageStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
        imageStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        imageStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10),
      ]
    )
  }
}
