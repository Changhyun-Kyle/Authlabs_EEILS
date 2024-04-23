//
//  UIImage+.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/23/24.
//

import UIKit

extension UIImage {
  func crop(to rect: CGRect) -> UIImage? {
    guard
      let cgImage = self.cgImage
    else {
      return nil
    }
    
    let rect = CGRect(
      x: rect.minX,
      y: rect.minY,
      width: rect.width,
      height: rect.height
    )
    
    guard
      let croppedImage = cgImage.cropping(to: rect)
    else {
      return nil
    }
    return UIImage(cgImage: croppedImage)
  }
}
