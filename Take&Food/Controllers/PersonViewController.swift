//
//  PersonViewController.swift
//  Take&Food
//
//  Created by Vladislav on 4/24/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var announcements: [Announcement]?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let announcementList: UITableView = {
        let list = UITableView()
        list.translatesAutoresizingMaskIntoConstraints = false
        return list
    }()
    
//    let infoStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.distribution = .fill
//        stack.alignment = .center
//        return stack
//    }()
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//    override func loadView() {
//        super.loadView()
//

//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Profile"
        announcementList.delegate = self
        announcementList.dataSource = self
        announcementList.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        view.backgroundColor = .white
        
        
        view.addSubview(emailLabel)
        emailLabel.text = "Email: \(SessionEntity.user.email ?? " ")"
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.addSubview(announcementList)
        
        
        view.addSubview(nameLabel)
        nameLabel.text = "Name: \(SessionEntity.user.name ?? " ")"
        
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            emailLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            emailLabel.heightAnchor.constraint(equalToConstant: 30),
            
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            containerView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            announcementList.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            announcementList.topAnchor.constraint(equalTo: containerView.topAnchor),
            announcementList.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            announcementList.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if(SessionEntity.user.status == 0) {
//            fetchData()
//        }
//    }
    
    func fetchData() {
        TAFNetwork.request(router: .getAnnouncementsForPerson(id: SessionEntity.user.id!)) { (result: Result<[Announcement], Error>) in
            switch result {
            case .success(let data):
                self.announcements = data
                DispatchQueue.main.async {
                    self.announcementList.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.announcements?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = announcements?[indexPath.row].date
        cell.textLabel?.textColor = announcements?[indexPath.row].status == 0 ? .systemYellow : .systemGreen
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
