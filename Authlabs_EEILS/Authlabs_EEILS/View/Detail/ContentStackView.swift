//
//  ContentStackView.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/25/24.
//

import UIKit

final class ContentStackView: UIStackView {
  private var definitionTitle: UILabel = {
    let label = UILabel()
    label.text = "정의"
    label.font = .preferredFont(for: .body, weight: .bold)
    label.textColor = .systemOrange
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var definitionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var definitionStackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [
        definitionTitle,
        definitionLabel
      ]
    )
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .leading
    stackView.spacing = 3
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private var descriptionTitle: UILabel = {
    let label = UILabel()
    label.text = "설명"
    label.font = .preferredFont(for: .body, weight: .bold)
    label.textColor = .systemOrange
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var descriptionStackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [
        descriptionTitle,
        descriptionLabel
      ]
    )
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .leading
    stackView.spacing = 3
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(definition: String, description: String) {
    definitionLabel.text = definition
    descriptionLabel.text = description
  }
}

private extension ContentStackView {
  func configureUI() {
    self.axis = .vertical
    self.spacing = 5
    self.distribution = .fill
    self.addArrangedSubview(definitionStackView)
    self.addArrangedSubview(descriptionStackView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate(
      [
        definitionStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        definitionStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        descriptionStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        descriptionStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      ]
    )
  }
}
