//
//  DetailView.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/25/24.
//

import UIKit

final class DetailView: UIView {
  private let contentStackView = ContentStackView()
  private let contentImageStackView = ContentImageStackView()
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "분석결과"
    label.textAlignment = .left
    label.textColor = .black
    label.font = .preferredFont(for: .largeTitle, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    configureUI()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(
    definition: String,
    description: String,
    captureImage: UIImage,
    originalImage: UIImage
  ) {
    contentStackView.configure(definition: definition, description: description)
    contentImageStackView.configure(captureImage: captureImage, originalImage: originalImage)
  }
}

private extension DetailView {
  func configureUI() {
    self.addSubview(titleLabel)
    self.addSubview(contentStackView)
    self.addSubview(contentImageStackView)
  }
  
  func setupConstraints() {
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    contentImageStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        contentStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
        contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        contentImageStackView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 10),
        contentImageStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        contentImageStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        contentImageStackView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height * 0.3),
      ]
    )
  }
}
