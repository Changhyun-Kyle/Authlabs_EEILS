//
//  TabbarController.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/29/24.
//

import UIKit

final class TabbarController: UITabBarController {
  override func loadView() {
    super.loadView()
    configureUI()
  }
}

private extension TabbarController {
  func configureUI() {
    let arViewController = ARViewController()
    let imageViewController = ImageViewController()
    let saveViewController = SaveViewController()
    let statusVC = StatusViewController()
    arViewController.addChild(statusVC)
    arViewController.view.addSubview(statusVC.view)
    statusVC.didMove(toParent: arViewController)
    imageViewController.tabBarItem = UITabBarItem(
      title: "이미지",
      image: UIImage(
        systemName: "photo.badge.plus"
      ),
      tag: 0
    )
    arViewController.tabBarItem = UITabBarItem(
      title: "카메라",
      image: UIImage(
        systemName: "camera.metering.center.weighted"
      ),
      tag: 1
    )
    saveViewController.tabBarItem = UITabBarItem(
      title: "저장목록",
      image: UIImage(
        systemName: "list.bullet"
      ),
      tag: 2
    )
    self.tabBar.tintColor = .systemOrange
    self.tabBar.barStyle = .black
    self.setViewControllers(
      [
        UINavigationController(rootViewController: imageViewController),
        UINavigationController(rootViewController: arViewController),
        UINavigationController(rootViewController: saveViewController)
      ], 
      animated: true
    )
  }
}
