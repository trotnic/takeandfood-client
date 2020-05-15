////
////  DataService.swift
////  Take&Food
////
////  Created by Vladislav on 4/21/20.
////  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
////
//
//import Foundation
//import Alamofire
//
//struct DataService {
//    static func getUser() -> User {
//        let request = Alamofire.request(Router.user(id: 1)).responseJSON { (response) in
//            let data = try! JSONDecoder().decode(User.self, from: response.data!)
//        }
//    }
//}
