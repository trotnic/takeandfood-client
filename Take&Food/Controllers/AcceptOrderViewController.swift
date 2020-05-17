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
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let dateLable: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let dishList: UITableView = {
        let list = UITableView()
        list.translatesAutoresizingMaskIntoConstraints = false
        return list
    }()
    
    init(data: [String: Announcement], orderId: Int) {
        announcement = data.values.first!
        self.orderId = orderId
        super.init(nibName: nil, bundle: nil)
        fetchData(id: Int(data.keys.first!) ?? 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dishList.delegate = self
        dishList.dataSource = self
        dishList.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(decline)),
            UIBarButtonItem(image: UIImage(systemName: "checkmark.circle"), style: .plain, target: self, action: #selector(approve))
        ]
        
        view.addSubview(dateLable)
        dateLable.text = announcement.date
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dishList)
        view.addSubview(containerView)
        
        view.addSubview(nameLabel)
        nameLabel.text = "Name: "
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            dateLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            dateLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            dateLable.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 100),
            dateLable.heightAnchor.constraint(equalToConstant: 30),
            
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            containerView.topAnchor.constraint(equalTo: dateLable.bottomAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            dishList.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dishList.topAnchor.constraint(equalTo: containerView.topAnchor),
            dishList.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dishList.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        // Do any additional setup after loading the view.
    }
    
    @objc func decline() {
        TAFNetwork.delete(router: .deleteOrder(id: orderId)) { (result) in
            switch result {
            case .failure(let error):
                print(error)
                self.navigationController?.popViewController(animated: true)
            case .success(let response):
                print(response)
            }
        }
    }
    
    @objc func approve() {
        let order = Order(id: orderId, restaurantId: announcement.restaurantId, userId: person?.id, announcementId: announcement.id, status: 1)
        TAFNetwork.request(router: .updateOrder(order: order)) { (result: Result<Order, Error>) in
            switch result {
            case .success(let order):
                print(order)
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
                print(person)
                DispatchQueue.main.async {
                    self.nameLabel.text = "Name: \(person.name!)"
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = self.announcement.dishes?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.announcement.dishes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
