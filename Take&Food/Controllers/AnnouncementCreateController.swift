//
//  AnnouncementCreateController.swift
//  Take&Food
//
//  Created by Vladislav on 4/23/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class AnnouncementCreateController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{

    var dataList: [Dish]
    
    let dishList: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let nameInput: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Enter name"
        field.tag = 0
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let amountInput: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Enter amount in grams"
        field.tag = 1
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        self.dataList = [Dish]()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.nameInput)
        self.view.addSubview(self.amountInput)
        self.view.addSubview(self.addButton)
        self.view.addSubview(self.submitButton)
        
        self.dishList.dataSource = self
        self.dishList.delegate = self
        self.amountInput.delegate = self
        self.nameInput.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark ? .black : .white

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Create announcement"
        
        
        self.dishList.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        containerView.addSubview(dishList)
        
        self.addButton.setTitleColor(.lightGray, for: .highlighted)
        self.submitButton.setTitleColor(.lightGray, for: .highlighted)
        
        self.addButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        self.submitButton.addTarget(self, action: #selector(submitList), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            nameInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nameInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            nameInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameInput.heightAnchor.constraint(equalToConstant: 40),
            
            amountInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            amountInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            amountInput.topAnchor.constraint(equalTo: self.nameInput.bottomAnchor, constant: 20),
            amountInput.heightAnchor.constraint(equalToConstant: 40),
            
            addButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            addButton.topAnchor.constraint(equalTo: self.amountInput.bottomAnchor, constant: 30),
            addButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10),
            submitButton.topAnchor.constraint(equalTo: self.amountInput.bottomAnchor, constant: 30),
            submitButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            
            containerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: self.submitButton.bottomAnchor, constant: 60),
            containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            dishList.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dishList.topAnchor.constraint(equalTo: containerView.topAnchor),
            dishList.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dishList.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        configureBackground()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureBackground()
    }
    
    func configureBackground() {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.addButton.setTitleColor(.white, for: .normal)
            self.addButton.layer.borderColor = UIColor.lightGray.cgColor
            self.submitButton.setTitleColor(.white, for: .normal)
            self.submitButton.layer.borderColor = UIColor.lightGray.cgColor
            self.view.backgroundColor = .black
        } else {
            self.addButton.setTitleColor(.black, for: .normal)
            self.submitButton.setTitleColor(.black, for: .normal)
            self.view.backgroundColor = .white
        }
    }
    
    @objc func addItem() {
        guard nameInput.text != "" && amountInput.text != "" else { return }
        self.dataList.append(Dish(id: nil, announcementId: nil, name: self.nameInput.text!, amount: Int(self.amountInput.text!)!))
        self.dishList.reloadData()
        DispatchQueue.main.async {
            self.nameInput.text = ""
            self.amountInput.text = ""
        }
    }
    
    @objc func submitList() {
        if dataList.count == 0 { return }
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let announcement = Announcement(id: nil, restaurantId: SessionEntity.user.restaurantId!, dishes: self.dataList, date: dateFormatter.string(from: date), status: 0)
        print(announcement)
        TAFNetwork.request(router: .createAnnouncement(form: announcement)) { (result: Result<Announcement, Error>) in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
        self.dataList = []
        DispatchQueue.main.async {
            self.dishList.reloadData()
            self.nameInput.text = ""
            self.amountInput.text = ""
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completion) in
            self.dataList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [checkAction])
    }
    
    
    // MARK: -TextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
                return true
            }
            return false
        } else {
            if CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: string)) {
                return true
            }
            return false
        }
    }
    
}
