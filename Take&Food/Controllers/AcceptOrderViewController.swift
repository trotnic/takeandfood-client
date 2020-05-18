//
//  AcceptOrderViewController.swift
//  Take&Food
//
//  Created by Vladislav on 5/17/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class AcceptOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var person: Person?
    var announcement: Announcement
    var orderId: Int
    var personId: Int
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dishList: UITableView = {
        let list = UITableView()
        list.translatesAutoresizingMaskIntoConstraints = false
        return list
    }()
    
    init(data: [String: Announcement], orderId: Int) {
        announcement = data.values.first!
        self.orderId = orderId
        self.personId = Int(data.keys.first!)!
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "#\(orderId)"
        view.addSubview(dateLable)
        view.addSubview(statusLabel)
        view.addSubview(nameLabel)
        fetchData(id: personId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dishList.delegate = self
        dishList.dataSource = self
        dishList.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(decline)),
            UIBarButtonItem(image: UIImage(systemName: "checkmark.circle"), style: .plain, target: self, action: #selector(approve))
        ]
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
        dateLable.text = dateFormatter.string(from: dateFormatter.date(from: announcement.date ?? "") ?? Date())
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dishList)
        view.addSubview(containerView)
        
        
        nameLabel.text = "Name:"
        statusLabel.text = "Status:"
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            dateLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dateLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            dateLable.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 100),
            dateLable.heightAnchor.constraint(equalToConstant: 30),
            
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: dateLable.bottomAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            dishList.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dishList.topAnchor.constraint(equalTo: containerView.topAnchor),
            dishList.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dishList.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            statusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20)
        ])
        configureBackground()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureBackground()
    }
    
    @objc func decline() {
        TAFNetwork.delete(router: .deleteOrder(id: orderId)) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                print(response)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func approve() {
        let order = Order(id: orderId, restaurantId: announcement.restaurantId, userId: person?.id, announcementId: announcement.id, status: 1)
        TAFNetwork.request(router: .updateOrder(order: order)) { (result: Result<Order, Error>) in
            switch result {
            case .success(let order):
                print(order)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchData(id: Int) {
        if (id == 0) { return }
        TAFNetwork.request(router: .getPerson(id: id)) { (result: Result<Person, Error>) in
            switch result {
            case .success(let person):
                self.person = person
                DispatchQueue.main.async {
                    self.nameLabel.text = "Name: \(person.name ?? "_")"
                    self.statusLabel.text = "Status: \(Status.allCases[person.status ?? 0].rawValue)"
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        cell.textLabel?.text = self.announcement.dishes?[indexPath.row].name
        cell.detailTextLabel?.text = "\(self.announcement.dishes?[indexPath.row].amount ?? 0)g"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.announcement.dishes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureBackground() {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.view.backgroundColor = .black
        } else {
            self.view.backgroundColor = .white
        }
    }
}
