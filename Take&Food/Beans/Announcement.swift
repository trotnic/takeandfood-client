//
//  Announcement.swift
//  Take&Food
//
//  Created by Vladislav on 4/21/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation


struct Announcement: Codable {
    let id: Int?
    let restaurantId: Int?
    let dishes: [Dish]?
    let date: String?
    let status: Int?
}
