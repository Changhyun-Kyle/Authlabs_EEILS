//
//  MarkerConfigureViewController.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/30/24.
//

import UIKit

final class MarkerConfigureViewController: UIViewController {
  private var imageStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .leading
    stackView.distribution = .equalSpacing
    stackView.spacing = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [
        definitionLabel,
        definitionTextView,
        descriptionLabel,
        descriptionTextView
      ]
    )
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .equalSpacing
    stackView.spacing = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  private var definitionLabel: UILabel = {
    let label = UILabel()
    label.text = "정의"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  private var definitionTextView: UITextView = {
    let textView = UITextView()
    textView.layer.cornerRadius = 10
    textView.layer.borderColor = UIColor.systemOrange.cgColor
    textView.layer.borderWidth = 3
    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
  }()
  private var descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "설명"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  private var descriptionTextView: UITextView = {
    let textView = UITextView()
    textView.layer.cornerRadius = 10
    textView.layer.borderColor = UIColor.systemOrange.cgColor
    textView.layer.borderWidth = 3
    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
  }()
}

private extension MarkerConfigureViewController {
  func configureUI() {
    view.addSubviews(
      imageStackView,
      contentStackView
    )
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate(
      [
        
      ]
    )
  }
}

extension UIView {
  func addSubviews(_ views: UIView...) {
    for view in views {
      self.addSubview(view)
    }
  }
}
