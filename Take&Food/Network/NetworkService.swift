//
//  NetworkService.swift
//  Take&Food
//
//  Created by Vladislav on 5/15/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import Foundation


struct TAFNetwork {
    static func delete(router: TAFRouter, completion: @escaping (Result<HTTPURLResponse, Error>) -> ()) {
        var components = URLComponents()
        components.host = router.host
        components.scheme = router.scheme
        components.path = router.path
        components.queryItems = router.components
        components.port = router.port
        guard let url = components.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard response != nil else { return }
            
            DispatchQueue.main.async {
                completion(.success(response as! HTTPURLResponse))
            }
        }.resume()
    }
    
    static func request<T: Codable>(router: TAFRouter, completion: @escaping (Result<T, Error>) -> ()) {
        var components = URLComponents()
        components.host = router.host
        components.scheme = router.scheme
        components.path = router.path
        components.queryItems = router.components
        components.port = router.port
        guard let url = components.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        if router.method == "POST" || router.method == "PUT" {
            urlRequest.httpBody = router.body
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard response != nil else { return }
            
            guard let data = data else { return }
            
            guard let responseObject = try? JSONDecoder().decode(T.self, from: data) else { return }
            
            DispatchQueue.main.async {
                completion(.success(responseObject))
            }
        }.resume()
    }
    
}
