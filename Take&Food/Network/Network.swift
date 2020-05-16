//
//  Network.swift
//  Take&Food
//
//  Created by Vladislav on 4/21/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {

    var path: String {
        switch self {
        case .getUser, .createUser, .deleteUser, .getUsers:
            return Constants.user
        case .getRestaurants, .getRestaurant, .createRestaurant:
            return Constants.restaurant
        case .getAnnouncements,
             .createAnnouncement:
            return Constants.announcement
            
        case .getFeedbackForId,
             .createFeedback:
            return Constants.feedback
        }
    }
    
    var action: String {
        switch self {
        case .getUser,
             .getRestaurant,
             .createRestaurant,
             .createUser,
             .deleteUser,
             .createFeedback,
             .createAnnouncement:
            return Constants.blank
        case .getUsers,
             .getRestaurants,
             .getAnnouncements,
             .getFeedbackForId:
            return Constants.all
        }
    }
    
    var parameters: [String : Any] {
        var paramDict: [String : Any] = [:]
        switch self {
        case .deleteUser(let id),
             .getUser(let id),
             .getRestaurant(let id),
             .getFeedbackForId(let id):
            paramDict["id"] = id
            break
        case let .createUser(id, name, login, password, email, role, status):
            paramDict["id"] = id
            paramDict["name"] = name
            paramDict["login"] = login
            paramDict["password"] = password
            paramDict["email"] = email
            paramDict["role"] = role
            paramDict["status"] = status
            break
        case .getUsers,
             .getRestaurants,
             .getAnnouncements:
            break
        case .createRestaurant(let restaurant): do {
            paramDict["name"] = restaurant.name
            var administrators = [Int]()
            for admin in restaurant.administrators! {
                administrators.append(admin.id!)
            }
            paramDict["administrators"] = administrators
            break
        }
        case .createFeedback(let restaurantID, let userID, let text, let date):
            paramDict["restaurantID"] = restaurantID
            paramDict["userID"] = userID
            paramDict["text"] = text
            paramDict["date"] = date
            break
        case .createAnnouncement(let announcement): do {
            var dishList = Array<[String:Any]>()
            for item in announcement.dishes! {
                var dishTmp: [String:Any] = [:]
                dishTmp["name"] = item.name
                dishTmp["amount"] = item.amount
                dishList.append(dishTmp)
            }
            paramDict["dishes"] = dishList
            paramDict["date"] = announcement.date
            paramDict["ownerID"] = announcement.restaurantId!
            break
            }
        }
        
        return paramDict
    }
        
    var method: HTTPMethod {
        switch self {
        case .getUser,
             .getUsers,
             .getRestaurants,
             .getRestaurant,
             .getAnnouncements,
             .getFeedbackForId:
            return .get
        case .deleteUser:
            return .delete
        case .createRestaurant,
             .createUser,
             .createFeedback,
             .createAnnouncement:
            return .post
        }
        
    }

    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path).appendingPathComponent(action))
        
        urlRequest.httpMethod = method.rawValue
       
        switch self {
        case .createFeedback,
             .createRestaurant,
             .createAnnouncement:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            return try URLEncoding.methodDependent.encode(urlRequest, with: parameters)
        }
    }
    
    case getUser(id: Int)
    case getUsers
    case createUser(id: Int, name: String, login: String, password: String, email: String, role: Int, status: Int)
    case deleteUser(id: Int)
    
    case getRestaurant(id: Int)
    case getRestaurants
    case createRestaurant(restaurant: Restaurant)
    
    case getAnnouncements
    case createAnnouncement(announcement: Announcement)
    
    case getFeedbackForId(id: Int)
    case createFeedback(restaurantID: Int, userID: Int, text: String, date: String)
}


struct Constants {
    static let blank = ""
    static let baseUrl = "http://127.0.0.1:8080"
    static let user = "/person"
    static let restaurant = "/restaurant"
    static let announcement = "/announcement"
    static let feedback = "/feedback"
    
    static let all = "/all"
}
