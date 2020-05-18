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
        label.backgroundColor = .clear
        label.text = SessionEntity.user.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = SessionEntity.user.email ?? ""
        return label
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = SessionEntity.user.login
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Status.allCases[SessionEntity.user.status!].rawValue
        return label
    }()
    
    let announcementList: UITableView = {
        let list = UITableView()
        list.translatesAutoresizingMaskIntoConstraints = false
        return list
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Profile"
        self.view.backgroundColor = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark ? .black : .white
        announcementList.delegate = self
        announcementList.dataSource = self
        announcementList.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "edit", style: .plain, target: self, action: #selector(edit)),
            UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logout))
        ]
        
        view.addSubview(emailLabel)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(statusLabel)
        
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.addSubview(announcementList)
        
        
        nameLabel.text = SessionEntity.user.name
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            emailLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            emailLabel.heightAnchor.constraint(equalToConstant: 40),
            
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            loginLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            loginLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            loginLabel.heightAnchor.constraint(equalToConstant: 40),
            
            statusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            statusLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            statusLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 10),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            containerView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            announcementList.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            announcementList.topAnchor.constraint(equalTo: containerView.topAnchor),
            announcementList.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            announcementList.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        setupSupplementaryViews()
    }
    
    func setupSupplementaryViews() {
        
        let nameSup = UIImageView(image: UIImage(systemName: "person.fill"))
        nameSup.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        nameSup.translatesAutoresizingMaskIntoConstraints = false
        
        let emailSup = UIImageView(image: UIImage(systemName: "envelope.fill"))
        emailSup.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        emailSup.translatesAutoresizingMaskIntoConstraints = false
        
        let loginSup = UIImageView(image: UIImage(systemName: "flame.fill"))
        loginSup.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        loginSup.translatesAutoresizingMaskIntoConstraints = false
        
        let statusSup = UIImageView(image: UIImage(systemName: "suit.spade.fill"))
        statusSup.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        statusSup.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(nameSup)
        self.view.addSubview(emailSup)
        self.view.addSubview(loginSup)
        self.view.addSubview(statusSup)
        
        NSLayoutConstraint.activate([
            nameSup.trailingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor, constant: -10),
            nameSup.lastBaselineAnchor.constraint(equalTo: self.nameLabel.lastBaselineAnchor, constant: -10),
            
            emailSup.trailingAnchor.constraint(equalTo: self.emailLabel.leadingAnchor, constant: -10),
            emailSup.lastBaselineAnchor.constraint(equalTo: self.emailLabel.lastBaselineAnchor, constant: -7),
            
            loginSup.trailingAnchor.constraint(equalTo: self.loginLabel.leadingAnchor, constant: -10),
            loginSup.lastBaselineAnchor.constraint(equalTo: self.loginLabel.lastBaselineAnchor, constant: -8),
            
            statusSup.trailingAnchor.constraint(equalTo: self.statusLabel.leadingAnchor, constant: -10),
            statusSup.lastBaselineAnchor.constraint(equalTo: self.statusLabel.lastBaselineAnchor, constant: -4)
            
        ])
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.userInterfaceStyle == UIUserInterfaceStyle.dark {
            self.view.backgroundColor = .white
        } else {
            self.view.backgroundColor = .black
        }
    }
    
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
    
    @objc func logout() {
        NotificationCenter.default.post(Notification(name: Notification.Name("logout"), object: nil, userInfo: nil))
        SessionEntity.user = Person(id: nil, name: nil, login: nil, password: nil, email: nil, restaurantId: nil, role: nil, status: nil)
    }
    
    @objc func edit() {
        self.navigationController?.pushViewController(PersonEditController(), animated: true)
    }
}
