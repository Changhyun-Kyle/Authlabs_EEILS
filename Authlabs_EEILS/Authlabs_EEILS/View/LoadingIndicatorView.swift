//
//  LoadingIndicatorView.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/25/24.
//

import UIKit
import Lottie

enum LoadingIndicatorView {
  static func showLoading(in view: UIView) {
    let animationView: LottieAnimationView
    
    guard
      let existedView = view.subviews.first(where: { $0 is LottieAnimationView } ) as? LottieAnimationView
    else {
      animationView = .init(name: "Animation - 1714042188329")
      animationView.frame = view.bounds
      animationView.contentMode = .scaleAspectFit
      animationView.loopMode = .loop
      animationView.animationSpeed = 0.5
      animationView.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
      view.addSubview(animationView)
      animationView.play()
      return
    }
    animationView = existedView
    animationView.play()
  }
  
  static func hideLoading(in view: UIView) {
    DispatchQueue.main.async {
      view.subviews.filter({ $0 is LottieAnimationView }).forEach { $0.removeFromSuperview() }
    }
  }
}
