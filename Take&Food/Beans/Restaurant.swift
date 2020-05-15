//
//  Restaurant.swift
//  Take&Food
//
//  Created by Vladislav on 4/21/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation


struct Restaurant: Codable {
    let id: Int?
    let name: String
    let administrators: [User]
}
