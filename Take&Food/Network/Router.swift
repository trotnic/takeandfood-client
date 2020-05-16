//
//  Router.swift
//  Take&Food
//
//  Created by Vladislav on 5/15/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation


enum TAFRouter {
    case getAnnouncementAll(page: Int)
    case getAnnouncementById(id: Int)
    
    case getRestaurantAll(page: Int)
    case getRestaurantById(id: Int)
    case getRestaurantFeedback(id: Int)
    
    case getFeedbackAll(page: Int)
    case getFeedbackById(id: Int)
    
    case login(form: AuthEntity)
    
    
    var scheme: String {
        return "http"
    }
    
    var host: String {
        return "localhost"
    }
    
    var port: Int {
        return 8080
    }
    
    var path: String {
        switch self {
        case .getAnnouncementAll:
            return "/announcement/all"
        case .getFeedbackAll:
            return "/feedback/all"
        case .getRestaurantAll:
            return "/restaurant/all"
        case .getAnnouncementById:
            return "/announcement"
        case .getRestaurantById:
            return "/restaurant"
        case .getFeedbackById:
            return "/feedback"
        case .getRestaurantFeedback:
            return "/restaurant/feedback"
        case .login:
            return "/auth/login"
        }
    }
    
    var components: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        switch self {
        case .getAnnouncementAll(let page):
            fallthrough
        case .getFeedbackAll(let page):
            fallthrough
        case .getRestaurantAll(let page):
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
            break
        case .getFeedbackById(let id):
            fallthrough
        case .getAnnouncementById(let id):
            fallthrough
        case .getRestaurantById(let id):
            fallthrough
        case .getRestaurantFeedback(let id):
            queryItems.append(URLQueryItem(name: "id", value: String(id)))
        case .login:
            break
        }
        return queryItems
    }
    
    var body: Data {
        switch self {
        case .login(let form):
            return try! JSONEncoder().encode(form)
            
        default:
            return Data()
        }
    }
    
    var method: String {
        switch self {
        case .getAnnouncementAll,
             .getAnnouncementById,
             .getFeedbackAll,
             .getFeedbackById,
             .getRestaurantAll,
             .getRestaurantById,
             .getRestaurantFeedback:
            return "GET"
        case .login:
            return "POST"
        }
    }
}
