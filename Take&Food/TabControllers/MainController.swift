//
//  MainController.swift
//  Take&Food
//
//  Created by Vladislav on 4/21/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class MainController: UITabBarController {

    override func loadView() {
        super.loadView()

        self.view.backgroundColor = .white
        
        let vc1 = UINavigationController()
        vc1.viewControllers = [PersonViewController()]
        vc1.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 0)
        
        let vc2 = UINavigationController()
        vc2.viewControllers = [RestaurantListController()]
        vc2.tabBarItem = UITabBarItem(title: "Restaurants", image: UIImage(systemName: "wand.and.stars"), tag: 1)
        
        let vc3 = UINavigationController()
        vc3.viewControllers = [RestaurantCreateController()]
        vc3.tabBarItem = UITabBarItem(title: "R_Create", image: UIImage(systemName: "scissors"), tag: 2)
        
        let vc4 = UINavigationController()
        vc4.viewControllers = [AnnouncementListController()]
        vc4.tabBarItem = UITabBarItem(title: "Announcements", image: UIImage(systemName: "wand.and.stars"), tag: 3)
        
        let vc5 = UINavigationController()
        vc5.viewControllers = [AnnouncementCreateController()]
        vc5.tabBarItem = UITabBarItem(title: "A_Create", image: UIImage(systemName: "scissors"), tag: 4)
        
        self.viewControllers = [vc1, vc2, vc3, vc4, vc5]
        self.selectedIndex = 0
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
