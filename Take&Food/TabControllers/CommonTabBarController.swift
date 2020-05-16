//
//  CommonTabBar.swift
//  Take&Food
//
//  Created by Vladislav on 5/16/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class CommonMainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController()
        vc1.viewControllers = [PersonViewController()]
        vc1.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 0)
        
        
        let vc2 = UINavigationController()
        vc2.viewControllers = [RestaurantListController()]
        vc2.tabBarItem = UITabBarItem(title: "Restaurants", image: UIImage(systemName: "wand.and.stars"), tag: 1)
        
        let vc3 = UINavigationController()
        vc3.viewControllers = [AnnouncementListController()]
        vc3.tabBarItem = UITabBarItem(title: "Announcements", image: UIImage(systemName: "scissors"), tag: 2)
        
        viewControllers = [vc1, vc2, vc3]
    }
}
