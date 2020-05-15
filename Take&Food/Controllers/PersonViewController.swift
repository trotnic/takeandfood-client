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
    
    let listUsersButton: UIButton
    
    init() {
        self.nameLabel = UILabel()
        self.emailLabel = UILabel()
        self.loginLabel = UILabel()
        self.listUsersButton = UIButton()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Profile"
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.loginLabel.translatesAutoresizingMaskIntoConstraints = false
        self.listUsersButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.emailLabel)
        self.view.addSubview(self.loginLabel)
        self.view.addSubview(self.listUsersButton)
        
        
        self.listUsersButton.setTitle("List users", for: .normal)
        self.listUsersButton.setTitleColor(.black, for: .normal)
        self.listUsersButton.setTitleColor(.lightGray, for: .highlighted)
        
        self.listUsersButton.addTarget(self, action: #selector(doThings(sender:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            self.loginLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 20),
            self.loginLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            
            self.emailLabel.topAnchor.constraint(equalTo: self.loginLabel.bottomAnchor, constant: 20),
            self.emailLabel.leadingAnchor.constraint(equalTo: self.loginLabel.leadingAnchor),
            
            self.listUsersButton.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor, constant: 30),
            self.listUsersButton.leadingAnchor.constraint(equalTo: self.emailLabel.leadingAnchor)
        
        ])
        
        
        Alamofire.request(Router.getUser(id: 1)).responseJSON { (response) in
            let data = try! JSONDecoder().decode(User.self, from: response.data!)
            self.emailLabel.text = data.email
            self.nameLabel.text = data.name
            self.loginLabel.text = data.login
        }
        
        // Do any additional setup after loading the view.
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
