//
//  OrdersListControllerTableViewController.swift
//  Take&Food
//
//  Created by Vladislav on 5/17/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class OrdersListControllerTableViewController: UITableViewController {

    var orders: [[String: [String: Announcement]]] = []
    
    func fetchData() {
        TAFNetwork.request(router: .getOrdersForRestaurant(id: SessionEntity.user.restaurantId!)) { (result: Result<[Order], Error>) in
            switch result {
            case .success(let data):
                for order in data {
                    TAFNetwork.request(router: .getAnnouncementById(id: order.announcementId!)) { (result: Result<Announcement, Error>) in
                        switch result {
                        case .success(let announcement):
                            self.orders.append(["\(order.id!)": ["\(order.userId!)":announcement]])
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Orders"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.orders = []
        fetchData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = self.orders[indexPath.row].keys.first
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(AcceptOrderViewController(data: self.orders[indexPath.row].values.first!, orderId: Int(self.orders[indexPath.row].keys.first!)!), animated: true)
    }
}
