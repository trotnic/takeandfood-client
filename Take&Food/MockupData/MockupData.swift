//
//  MockupData.swift
//  Take&Food
//
//  Created by Vladislav on 5/16/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation



struct MockupData {
    static let user = Person(id: 5,
                             name: "vladislav",
                             login: "trotnic",
                             password: "password",
                             email: "email@meal.com",
                             restaurantId: 6,
                             role: 1,
                             status: 0)
    static let authUser = AuthEntity(login: "trotnic",
                                     password: "password",
                                     status: nil, role: nil)
}

