//
//  RestaurantViewController.swift
//  Take&Food
//
//  Created by Vladislav on 4/22/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantViewController: UIViewController, UITableViewDataSource {

    let restaurant: Restaurant
    var feedView: UITableView
    var feedData: [Feedback]?
    var inputField: UITextField
    var submitButton: UIButton

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        self.feedView = UITableView()
        self.inputField = UITextField()
        self.submitButton = UIButton()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Create restaurant"
        
        
        self.view.addSubview(feedView)
        self.view.addSubview(self.inputField)
        self.view.addSubview(self.submitButton)
        self.feedView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        self.feedView.translatesAutoresizingMaskIntoConstraints = false
        self.inputField.translatesAutoresizingMaskIntoConstraints = false
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.submitButton.setTitle("Submit", for: .normal)
        self.submitButton.setTitleColor(.black, for: .normal)
        self.submitButton.setTitleColor(.red, for: .highlighted)
        self.submitButton.titleLabel?.textAlignment = .center
        self.submitButton.addTarget(self, action: #selector(submitData(sender:)), for: .touchUpInside)
        
        self.inputField.borderStyle = .roundedRect
        self.inputField.placeholder = "Type comment.."
        
        self.feedView.dataSource = self
        
        
        
        self.view.backgroundColor = .white
        self.navigationItem.title = restaurant.name
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
//        UILabel name = 
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            self.feedView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.feedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.feedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.feedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -300),
            
            self.inputField.topAnchor.constraint(equalTo: self.feedView.bottomAnchor, constant: 30),
            self.inputField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.inputField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.inputField.heightAnchor.constraint(equalToConstant: 40),
            
            self.submitButton.leadingAnchor.constraint(equalTo: self.inputField.leadingAnchor),
            self.submitButton.topAnchor.constraint(equalTo: self.inputField.bottomAnchor, constant: 30),
            self.submitButton.trailingAnchor.constraint(equalTo: self.inputField.trailingAnchor),
            self.submitButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    func fetchData() {
        Alamofire.request(URL(string: "http://127.0.0.1:8080/feedback/restaurant")!, method: .get, parameters: ["id": self.restaurant.id!], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            self.feedData = try! JSONDecoder().decode([Feedback].self, from: response.data!)
            DispatchQueue.main.async {
                self.feedView.reloadData()
            }
        }
//        Alamofire.request(Router.getFeedbackForId(id: self.restaurant.id!)).responseJSON { (response) in
//            self.feedData = try! JSONDecoder().decode([Feedback].self, from: response.data!)
//            DispatchQueue.main.async {
//                self.feedView.reloadData()
//            }
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func submitData(sender: UIButton) {
        
        if(self.inputField.text == "") {
            return
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        Alamofire.request(Router.createFeedback(restaurantID: self.restaurant.id!, userID: 1, text: self.inputField.text!, date: dateFormatter.string(from: date))).responseJSON { (response) in
            print(response)
        }
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
