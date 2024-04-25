//
//  UIFont+.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/25/24.
//

import UIKit

extension UIFont {
  static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
    let metrics = UIFontMetrics(forTextStyle: style)
    let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
    let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
    return metrics.scaledFont(for: font)
  }
}
