//
//  Switcher.swift
//  Take&Food
//
//  Created by Vladislav on 5/16/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation
import UIKit


class Switcher {
    static func updateRootVc() {
         let status = UserDefaults.standard.bool(forKey: "status")
         var rootVc : UIViewController
        
         print(status)
         

         if(status == true){
            rootVc = MainController()
//             rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarvc") as! TabBarVC
         }else{
            rootVc = LoginViewController()
//             rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginvc") as! LoginVC
         }
         
//        var appDeletage = AppDelegate()
//        appDeletage.window
//        let sceneDelegate = SceneDelegate
//        sceneDelegate.
//         let appDelegate = UIApplication.shared.delegate as! AppDelegate
//         appDelegate.window?.rootViewController = rootVC
    }
}
