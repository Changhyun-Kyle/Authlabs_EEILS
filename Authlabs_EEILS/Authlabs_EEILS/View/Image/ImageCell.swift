//
//  ImageCell.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/29/24.
//

import UIKit

final class ImageCell: UICollectionViewCell {
  static var identifier: String {
    return String(describing: self)
  }
  private let imageView: UIImageView = .init()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(imageView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = self.bounds
  }
  
  func configure(image: UIImage) {
    self.imageView.image = image
  }
}
