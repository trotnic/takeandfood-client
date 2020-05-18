//
//  SceneDelegate.swift
//  Take&Food
//
//  Created by Vladislav on 4/21/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        window = UIWindow(windowScene: scene as! UIWindowScene)
        let vc = UINavigationController()
        vc.viewControllers = [InitialViewController()]
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeVc(notification:)), name: Notification.Name("authorizied"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logout(notification:)), name: Notification.Name("logout"), object: nil)
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    @objc func logout(notification: Notification) {
        let vc = UINavigationController()
        vc.viewControllers = [InitialViewController()]
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.window?.rootViewController?.dismiss(animated: false) {
                    self.window?.rootViewController = vc
                }
            }
        }
    }
    
    @objc func changeVc(notification: Notification) {
        if SessionEntity.user.role == 0 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    self.window?.rootViewController?.dismiss(animated: false) {
                        self.window?.rootViewController = AdministratorMainController()
                    }
                }
            }
        } else if SessionEntity.user.role == 1 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    self.window?.rootViewController?.dismiss(animated: true) {
                        self.window?.rootViewController = CommonMainController()
                    }
                }
            }
        }
    }
}

