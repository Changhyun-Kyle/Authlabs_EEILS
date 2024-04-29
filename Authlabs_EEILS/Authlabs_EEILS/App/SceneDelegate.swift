//
//  SceneDelegate.swift
//  Authlabs_EEILS
//
//  Created by 강창현 on 4/22/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
//    let rootViewController = ARViewController()
    let rootViewController = TabbarController()
//    let statusVC = StatusViewController()
//    rootViewController.addChild(statusVC)
//    rootViewController.view.addSubview(statusVC.view)
//    statusVC.didMove(toParent: rootViewController)
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) { }

  func sceneDidBecomeActive(_ scene: UIScene) { }

  func sceneWillResignActive(_ scene: UIScene) { }

  func sceneWillEnterForeground(_ scene: UIScene) { }

  func sceneDidEnterBackground(_ scene: UIScene) { }
}

