//
//  Order.swift
//  Take&Food
//
//  Created by Vladislav on 5/16/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation


struct Order: Codable {
    var id: Int?
    var restaurantId: Int?
    var userId: Int?
    var announcementId: Int?
    var status: Int?
}
