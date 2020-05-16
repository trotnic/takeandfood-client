//
//  SessionEntity.swift
//  Take&Food
//
//  Created by Vladislav on 5/16/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation

struct SessionEntity {
    public static var user: Person = Person(id: nil, name: nil, login: nil, password: nil, email: nil, restaurantId: nil, role: nil, status: nil)
    
    init(user: Person) {
        SessionEntity.user = user
    }
}
