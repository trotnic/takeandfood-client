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
    case getAnnouncementsForPerson(id: Int)
    case deleteAnnouncement(id: Int)
    case createAnnouncement(form: Announcement)
    
    case getRestaurantAll(page: Int)
    case getRestaurantById(id: Int)
    case getRestaurantFeedback(id: Int)
    
    case getFeedbackAll(page: Int)
    case getFeedbackById(id: Int)
    case createFeedback(form: Feedback)
    
    case getOrdersForRestaurant(id: Int)
    case updateOrder(order: Order)
    case deleteOrder(id: Int)
    
    case getPerson(id: Int)
    case updatePerson(form: Person)
    
    case login(form: AuthEntity)
    
    case createOrder(form: Order)
    
    case register(form: AuthEntity)
    
    
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
        case .getAnnouncementsForPerson:
            return "/announcement/person"
        case .getAnnouncementAll:
            return "/announcement/all"
        case .getFeedbackAll:
            return "/feedback/all"
        case .getRestaurantAll:
            return "/restaurant/all"
        case .getAnnouncementById,
             .deleteAnnouncement,
             .createAnnouncement:
            return "/announcement"
        case .getRestaurantById:
            return "/restaurant"
        case .getFeedbackById,
             .createFeedback:
            return "/feedback"
        case .getRestaurantFeedback:
            return "/restaurant/feedback"
        case .login:
            return "/auth/login"
        case .createOrder,
             .updateOrder,
             .deleteOrder:
            return "/order"
        case .getOrdersForRestaurant:
            return "/order/restaurant"
        case .getPerson,
             .updatePerson:
            return "/person"
        case .register:
            return "/auth/register"
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
            fallthrough
        case .getAnnouncementsForPerson(let id):
            fallthrough
        case .getOrdersForRestaurant(let id):
            fallthrough
        case .getPerson(let id):
            fallthrough
        case .deleteOrder(let id):
            fallthrough
        case .deleteAnnouncement(let id):
            queryItems.append(URLQueryItem(name: "id", value: String(id)))
        case .login,
             .createOrder,
             .createFeedback,
             .updateOrder,
             .createAnnouncement,
             .register,
             .updatePerson:
            break
        }
        return queryItems
    }
    
    var body: Data {
        switch self {
        case .login(let form):
            fallthrough
        case .register(let form):
            return try! JSONEncoder().encode(form)
        case .createOrder(let order):
            return try! JSONEncoder().encode(order)
        case .createFeedback(let feedback):
            return try! JSONEncoder().encode(feedback)
        case .updateOrder(let order):
            return try! JSONEncoder().encode(order)
        case .createAnnouncement(let form):
            return try! JSONEncoder().encode(form)
        case .updatePerson(let form):
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
             .getRestaurantFeedback,
             .getAnnouncementsForPerson,
             .getOrdersForRestaurant,
             .getPerson:
            return "GET"
        case .login,
             .createOrder,
             .createFeedback,
             .createAnnouncement,
             .register:
            return "POST"
        case .updateOrder,
             .updatePerson:
            return "PUT"
        case .deleteOrder,
             .deleteAnnouncement:
            return "DELETE"
        }
    }
}
