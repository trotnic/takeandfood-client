//
//  DishTableController.swift
//  Take&Food
//
//  Created by Vladislav on 4/23/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class DishTableController: UITableViewController {

    let data: Announcement
    
    init(announcement: Announcement) {
        self.data = announcement
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        if (SessionEntity.user.role == 1 && data.status == 0) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(orderOne))
        }
        
        if(SessionEntity.user.role == 0) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(deleteOne))
        }
    }

    // MARK: - Business logic
    
    @objc func deleteOne() {
        TAFNetwork.delete(router: .deleteAnnouncement(id: data.id!)) { (result) in
            switch result {
            case .success(let response):
                self.navigationController?.popViewController(animated: true)
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func orderOne() {
        let router = TAFRouter.createOrder(form: Order(id: nil, restaurantId: data.restaurantId, userId: SessionEntity.user.id, announcementId: data.id, status: 0))
        var components = URLComponents()
        components.host = router.host
        components.scheme = router.scheme
        components.path = router.path
        components.queryItems = router.components
        components.port = router.port
        let url = components.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        urlRequest.httpBody = router.body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                return
            }

            guard let response = response as? HTTPURLResponse else { return }
            
            guard let data = try? JSONDecoder().decode(Person.self, from: data!) else { return }
            
            if (response.statusCode == 200) {
                print(response)
//                UserDefaults.standard.set(true, forKey: "status")
//                SessionEntity.user = data
//                DispatchQueue.main.async {
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: "loggedIn"), object: nil)
//                }
//                return
            }
//            print(response.statusCode)
//            let responseObject = try! JSONDecoder().decode(AuthEntity.self, from: data)
        }.resume()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.dishes?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = self.data.dishes![indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
