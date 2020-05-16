//
//  Person.swift
//  Take&Food
//
//  Created by Vladislav on 4/21/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation

struct Person: Codable {
    let id: Int?
    let name: String?
    let login: String?
    let password: String?
    let email: String?
    let restaurantId: Int?
    let role: Int?
    let status: Int?
}
