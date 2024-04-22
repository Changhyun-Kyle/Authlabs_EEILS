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
  
  override func loadView() {
    super.loadView()
    configureUI()
    setupConstraints()
  }
  
  func setupNameLabel(name: String) {
    self.nameLabel.text = name
  }
}

private extension DetailViewController {
  func configureUI() {
    view.addSubview(nameLabel)
    view.backgroundColor = .white
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate(
      [
        nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        nameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      ]
    )
  }
}
