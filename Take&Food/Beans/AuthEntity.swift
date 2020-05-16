//
//  AuthEntity.swift
//  Take&Food
//
//  Created by Vladislav on 5/15/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation


struct AuthEntity: Codable {
    var login: String
    var password: String
    var status: Int?
    var role: Int?
}
