//
//  AnnouncementCreateController.swift
//  Take&Food
//
//  Created by Vladislav on 4/23/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit
import Alamofire

class AnnouncementCreateController: UIViewController, UITableViewDataSource {

    var dataList: [Dish]
    let dishList: UITableView
    let nameInput: UITextField
    let amountInput: UITextField
    let submitButton: UIButton
    let addButton: UIButton
    
    init() {
        self.dishList = UITableView()
        self.nameInput = UITextField()
        self.amountInput = UITextField()
        self.submitButton = UIButton()
        self.addButton = UIButton()
        self.dataList = [Dish]()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Create announcement"
        
        self.dishList.dataSource = self
        self.dishList.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.dishList.translatesAutoresizingMaskIntoConstraints = false
        self.nameInput.translatesAutoresizingMaskIntoConstraints = false
        self.amountInput.translatesAutoresizingMaskIntoConstraints = false
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.dishList)
        self.view.addSubview(self.nameInput)
        self.view.addSubview(self.amountInput)
        self.view.addSubview(self.addButton)
        self.view.addSubview(self.submitButton)
        
        self.nameInput.borderStyle = .roundedRect
        self.amountInput.borderStyle = .roundedRect
        
        self.nameInput.placeholder = "Type name.."
        self.amountInput.placeholder = "Type amount.."
        
        self.addButton.setTitle("Add", for: .normal)
        self.submitButton.setTitle("Submit", for: .normal)
        
        self.addButton.setTitleColor(.black, for: .normal)
        self.submitButton.setTitleColor(.black, for: .normal)
        
        self.addButton.titleLabel?.textAlignment = .center
        self.submitButton.titleLabel?.textAlignment = .center
        
        self.addButton.layer.borderWidth = 0.9
        self.submitButton.layer.borderWidth = 0.9
        
        self.addButton.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.submitButton.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        self.addButton.layer.cornerRadius = 5
        self.submitButton.layer.cornerRadius = 5
        
        self.addButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        self.submitButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        self.addButton.setTitleColor(.lightGray, for: .highlighted)
        self.submitButton.setTitleColor(.lightGray, for: .highlighted)
        
        self.addButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        self.submitButton.addTarget(self, action: #selector(submitList), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.dishList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.dishList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.dishList.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
            self.dishList.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -400),
            
            self.nameInput.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.nameInput.topAnchor.constraint(equalTo: self.dishList.bottomAnchor, constant: 30),
            self.nameInput.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
            
            self.amountInput.leadingAnchor.constraint(equalTo: self.nameInput.leadingAnchor),
            self.amountInput.topAnchor.constraint(equalTo: self.nameInput.bottomAnchor, constant: 15),
            self.amountInput.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
            
            self.addButton.leadingAnchor.constraint(equalTo: self.amountInput.leadingAnchor),
            self.addButton.topAnchor.constraint(equalTo: self.amountInput.bottomAnchor, constant: 30),
            self.addButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            self.submitButton.leadingAnchor.constraint(equalTo: self.addButton.trailingAnchor, constant: 20),
            self.submitButton.topAnchor.constraint(equalTo: self.addButton.topAnchor),
            self.submitButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        
        // Do any additional setup after loading the view.
    }
    
    @objc func addItem() {
        self.dataList.append(Dish(id: nil, announcementID: nil, name: self.nameInput.text!, amount: Int(self.amountInput.text!)!))
        self.nameInput.text = ""
        self.amountInput.text = ""
        self.dishList.reloadData()
    }
    
    @objc func submitList() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let announcement = Announcement(id: nil, ownerID: 3, dishes: self.dataList, date: dateFormatter.string(from: date))
        Alamofire.request(Router.createAnnouncement(announcement: announcement)).responseJSON { (response) in
            print(response)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = "\(self.dataList[indexPath.row].name): \(self.dataList[indexPath.row].amount)g"

        return cell;
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
