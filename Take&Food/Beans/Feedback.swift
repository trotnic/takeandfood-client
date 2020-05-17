//
//  Feedback.swift
//  Take&Food
//
//  Created by Vladislav on 4/21/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation


struct Feedback: Codable {
    let id: Int?
    let personId: Int?
    let restaurantId: Int?
    let text: String?
    let date: String?
}
