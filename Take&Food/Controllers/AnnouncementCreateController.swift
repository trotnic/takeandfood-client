//
//  AnnouncementCreateController.swift
//  Take&Food
//
//  Created by Vladislav on 4/23/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit
//import Alamofire

class AnnouncementCreateController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
    
    override func loadView() {
        super.loadView()
        
//        self.view.addSubview(self.dishList)
        self.view.addSubview(self.nameInput)
        self.view.addSubview(self.amountInput)
        self.view.addSubview(self.addButton)
        self.view.addSubview(self.submitButton)
        
        self.dishList.translatesAutoresizingMaskIntoConstraints = false
        self.nameInput.translatesAutoresizingMaskIntoConstraints = false
        self.amountInput.translatesAutoresizingMaskIntoConstraints = false
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.dishList.dataSource = self
        self.dishList.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Create announcement"
        
        
        self.dishList.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
//        dishList.frame = containerView.bounds
        containerView.addSubview(dishList)
        
        
        self.nameInput.backgroundColor = .white
        self.amountInput.backgroundColor = .white
        
        
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
            nameInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nameInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            nameInput.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameInput.heightAnchor.constraint(equalToConstant: 40),
            
            amountInput.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            amountInput.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            amountInput.topAnchor.constraint(equalTo: self.nameInput.bottomAnchor, constant: 20),
            amountInput.heightAnchor.constraint(equalToConstant: 40),
            
            addButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            addButton.topAnchor.constraint(equalTo: self.amountInput.bottomAnchor, constant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.leadingAnchor.constraint(equalTo: self.addButton.trailingAnchor, constant: 20),
            submitButton.topAnchor.constraint(equalTo: self.amountInput.bottomAnchor, constant: 30),
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
    }
    
    @objc func addItem() {
        guard nameInput.text != "" && amountInput.text != "" else { return }
        self.dataList.append(Dish(id: nil, announcementId: nil, name: self.nameInput.text!, amount: Int(self.amountInput.text!)!))
//        self.nameInput.text = ""
//        self.amountInput.text = ""
        self.dishList.reloadData()
    }
    
    @objc func submitList() {
        if dataList.count == 0 { return }
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
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
    

//    - (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
//        UIContextualAction *checkAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//            completionHandler(true);
//        }];
//
//        checkAction.backgroundColor = UIColor.systemRedColor;
//
//        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[checkAction]];
//
//        return config;
//    }
}
