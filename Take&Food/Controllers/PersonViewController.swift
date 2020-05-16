//
//  PersonViewController.swift
//  Take&Food
//
//  Created by Vladislav on 4/24/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit
import Alamofire

class PersonViewController: UIViewController {
    let nameLabel: UILabel
    let emailLabel: UILabel
    let loginLabel: UILabel
    
    init() {
        self.nameLabel = UILabel()
        self.emailLabel = UILabel()
        self.loginLabel = UILabel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Profile"
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        nameLabel.text = SessionEntity.user.name ?? "LOLKEK"
        loginLabel.text = SessionEntity.user.login!
        emailLabel.text = SessionEntity.user.email!
        
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.emailLabel)
        self.view.addSubview(self.loginLabel)
        
        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 200),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            
            self.loginLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 20),
            self.loginLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            
            self.emailLabel.topAnchor.constraint(equalTo: self.loginLabel.bottomAnchor, constant: 20),
            self.emailLabel.leadingAnchor.constraint(equalTo: self.loginLabel.leadingAnchor)
            
        
        ])
        
        
    }
    
    
    @objc func doThings(sender: UIButton) {
        self.navigationController?.pushViewController(PersonListController(), animated: true)
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
