//
//  RegistrationViewController.swift
//  Take&Food
//
//  Created by Vladislav on 5/17/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    let confirmPassword: UITextField = {
       let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Confirm password"
        field.borderStyle = .roundedRect
        return field
    }()
    
    let loginField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Enter login"
        field.borderStyle = .roundedRect
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Enter password"
        field.borderStyle = .roundedRect
        return field
    }()

    let statusControl: UISegmentedControl = {
        let stepper = UISegmentedControl()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.insertSegment(withTitle: "Student", at: 0, animated: true)
        stepper.insertSegment(withTitle: "Employee", at: 1, animated: true)
        stepper.insertSegment(withTitle: "Jobless", at: 2, animated: true)
        stepper.selectedSegmentIndex = 0
        
        return stepper
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Registration"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        view.addSubview(confirmPassword)
        view.addSubview(loginField)
        view.addSubview(statusControl)
        view.addSubview(submitButton)
        view.addSubview(passwordField)
        
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            loginField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            loginField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loginField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            loginField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmPassword.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            confirmPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            confirmPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            confirmPassword.heightAnchor.constraint(equalToConstant: 40),
            
            statusControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            statusControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            statusControl.topAnchor.constraint(equalTo: confirmPassword.bottomAnchor, constant: 40),
            statusControl.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            submitButton.topAnchor.constraint(equalTo: statusControl.bottomAnchor, constant: 40),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    func addAnnotations() {
        let nameAnno = UILabel()
        nameAnno.translatesAutoresizingMaskIntoConstraints = false
        nameAnno.text = "Name"
        nameAnno.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        self.view.addSubview(nameAnno)
        
        
        NSLayoutConstraint.activate([
            nameAnno.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameAnno.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            nameAnno.bottomAnchor.constraint(equalTo: confirmPassword.topAnchor, constant: 10),
            nameAnno.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc func register() {
        guard self.confirmPassword.text != "" && self.loginField.text != "" && self.passwordField.text != "" else { return }
        
        let form = AuthEntity(login: self.loginField.text!, password: self.passwordField.text!, status: self.statusControl.selectedSegmentIndex, role: 1)

        TAFNetwork.request(router: .register(form: form)) { (result: Result<Person, Error>) in
            switch result {
            case .success(let person):
                SessionEntity.user = person
                DispatchQueue.main.async {
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "authorizied"), object: nil, userInfo: nil))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
