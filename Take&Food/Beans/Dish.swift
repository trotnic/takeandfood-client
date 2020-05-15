//
//  Dish.swift
//  Take&Food
//
//  Created by Vladislav on 4/21/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation


struct Dish: Codable {
    let id: Int?
    let announcementID: Int?
    let name: String
    let amount: Int
}
