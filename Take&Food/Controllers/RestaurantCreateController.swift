//
//  RestaurantCreateController.swift
//  Take&Food
//
//  Created by Vladislav on 4/22/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit
import Alamofire


class RestaurantCreateController: UIViewController {

    let nameInput: UITextField
    
    init() {
        self.nameInput = UITextField()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Create restaurant"
        
        
        self.view.addSubview(self.nameInput)
        
        self.nameInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nameInput.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
            self.nameInput.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            self.nameInput.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
//            self.nameInput.heightAnchor.constraint(equalToConstant: 30)
        ])
        self.nameInput.borderStyle = .roundedRect
        self.nameInput.placeholder = "Type name.."
        
        
//        let nameLabel = UILabel()
//
//        self.view.addSubview(nameLabel)
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            nameLabel.bottomAnchor.constraint(equalTo: self.nameInput.topAnchor, constant: -20),
//            nameLabel.leadingAnchor.constraint(equalTo: self.nameInput.leadingAnchor)
//        ])
//
//        nameLabel.text = "Restaurant"
       
        
        
        
        let submitButton = UIButton()
        self.view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        submitButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: self.nameInput.leadingAnchor),
            submitButton.topAnchor.constraint(equalTo: self.nameInput.bottomAnchor, constant: 15),
//            submitButton.heightAnchor.constraint(equalToConstant: 30),
            submitButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        submitButton.layer.borderWidth = 0.9
        submitButton.setTitleColor(.lightGray, for: .highlighted)
        
        submitButton.addTarget(self, action: #selector(doShit), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func doShit() {
        let administrators = [User(id: 1, name: nil, login: nil, password: nil, email: nil, restaurantID: nil, role: nil, status: nil)]
        let restaurant = Restaurant(id: nil, name: self.nameInput.text!, administrators: administrators)
        Alamofire.request(Router.createRestaurant(restaurant: restaurant)).responseJSON { (response) in
            print(response)
        }
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
