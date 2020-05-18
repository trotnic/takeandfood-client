//
//  MockupData.swift
//  Take&Food
//
//  Created by Vladislav on 5/16/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation



struct MockupData {
    static let user = Person(id: 25,
                             name: "vladislav",
                             login: "trotnic",
                             password: "password",
                             email: "email@email.com",
                             restaurantId: 26,
                             role: 0,
                             status: 1)
    static let authUser = AuthEntity(login: "trotnic",
                                     password: "password",
                                     status: nil, role: nil)
}

