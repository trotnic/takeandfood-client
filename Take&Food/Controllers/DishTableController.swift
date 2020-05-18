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
    var restaurant: RestaurantShort?
    
    let restaurantLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    init(announcement: Announcement) {
        self.data = announcement
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(restaurantLabel)
        self.view.addSubview(addressLabel)
        fetchData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLayoutConstraint.activate([
            self.addressLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.addressLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.addressLabel.topAnchor.constraint(equalTo: self.restaurantLabel.bottomAnchor, constant: 40),
            self.addressLabel.heightAnchor.constraint(equalToConstant: 40),
            
            self.restaurantLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.restaurantLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.restaurantLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            self.restaurantLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
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
        let order = Order(
            id: nil,
            restaurantId: data.restaurantId,
            userId: SessionEntity.user.id,
            announcementId: data.id,
            status: 0
        )
        
        TAFNetwork.request(router: .createOrder(form: order)) { (result: Result<Order, Error>) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    NotificationCenter.default.post(Notification(name: Notification.Name("ordered")))
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchData() {
        TAFNetwork.request(router: .getRestaurantById(id: data.restaurantId!)) { (result: Result<RestaurantShort, Error>) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.restaurant = data
                    self.navigationItem.title = self.restaurant?.address
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.dishes?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        cell.textLabel?.text = self.data.dishes?[indexPath.row].name
        cell.detailTextLabel?.text = "\(self.data.dishes?[indexPath.row].amount ?? 0)g"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
