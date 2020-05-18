//
//  RestaurantViewController.swift
//  Take&Food
//
//  Created by Vladislav on 4/22/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit
//import Alamofire

class RestaurantViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let restaurant: Restaurant
    
    var feedView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var feedData: [Feedback]?
    
    var inputField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(restaurant: Restaurant) {
        
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(self.inputField)
        self.view.addSubview(self.addressLabel)
        fetchData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInput(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateInput(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.feedView.dataSource = self
        self.feedView.delegate = self
        self.feedView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.view.backgroundColor = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark ? .black : .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.addSubview(feedView)
        
        self.inputField.borderStyle = .roundedRect
        self.inputField.placeholder = "Type comment.."
        
        self.navigationItem.title = restaurant.name
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        button.frame = CGRect(x: inputField.bounds.width - 60, y: 5, width: 35, height: 35)
        button.addTarget(self, action: #selector(submitData(sender:)), for: .touchUpInside)
        
        inputField.rightView = button
        inputField.rightViewMode = .always
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: -10),
            containerView.bottomAnchor.constraint(equalTo: inputField.topAnchor, constant: -30),
            containerView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 50),
            
            feedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            feedView.topAnchor.constraint(equalTo: containerView.topAnchor),
            feedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            feedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            addressLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addressLabel.heightAnchor.constraint(equalToConstant: 30),
            
            inputField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            inputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            inputField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            inputField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.userInterfaceStyle == UIUserInterfaceStyle.dark {
            self.view.backgroundColor = .white
        } else {
            self.view.backgroundColor = .black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addressLabel.text = restaurant.address
    }
    
    @objc func updateInput(notification: Notification) {
        let rect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.view.bounds.height - rect.minY - 60, right: 0)
    }
    
    func setupInput(offset: CGFloat) {
    }

    func fetchData() {
        TAFNetwork.request(router: .getRestaurantFeedback(id: restaurant.id!)) { (result: Result<[Feedback], Error>) in
            switch result {
            case .success(let data):
                self.feedData = data
                DispatchQueue.main.async {
                    self.feedView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    @objc func submitData(sender: UIButton) {
        
        if(self.inputField.text == "") {
            return
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"

        TAFNetwork.request(
            router: .createFeedback(
                form: Feedback(
                    id: nil,
                    personId: SessionEntity.user.id,
                    restaurantId: restaurant.id,
                    text: self.inputField.text,
                    date: dateFormatter.string(from: date)))) { (result: Result<Feedback, Error>) in
                                        self.fetchData()}
        
        DispatchQueue.main.async {
            self.inputField.text = ""
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.feedData {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = self.feedData?[indexPath.row].text
        return cell
    }
    
}
