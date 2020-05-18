//
//  RegistrationViewController.swift
//  Take&Food
//
//  Created by Vladislav on 5/17/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {

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
    
    var loginWarn: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        
        label.backgroundColor = .clear
        label.alpha = 0
        return label
    }()
    
    var passwordWarn: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        
        label.backgroundColor = .clear
        label.alpha = 0
        return label
    }()
    
    var confirmationWarn: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        
        label.backgroundColor = .clear
        label.alpha = 0
        return label
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
        button.setTitle("Sign up", for: .normal)
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
        navigationItem.title = "Sign up"
        self.passwordField.delegate = self
        self.loginField.delegate = self
        self.confirmPassword.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        view.addSubview(confirmPassword)
        view.addSubview(loginField)
        view.addSubview(statusControl)
        view.addSubview(submitButton)
        view.addSubview(passwordField)
        view.addSubview(loginWarn)
        view.addSubview(passwordWarn)
        view.addSubview(confirmationWarn)
        
        self.confirmationWarn.text = "something to check"
        self.passwordWarn.text = "something to check"
        self.loginWarn.text = "something to check"
        
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            loginField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            loginField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loginField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            loginField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 30),
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmPassword.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            confirmPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            confirmPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            confirmPassword.heightAnchor.constraint(equalToConstant: 40),
            
            statusControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            statusControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            statusControl.topAnchor.constraint(equalTo: confirmPassword.bottomAnchor, constant: 30),
            statusControl.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            submitButton.topAnchor.constraint(equalTo: statusControl.bottomAnchor, constant: 40),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginWarn.heightAnchor.constraint(equalToConstant: 20),
            loginWarn.bottomAnchor.constraint(equalTo: loginField.topAnchor),
            loginWarn.leadingAnchor.constraint(equalTo: loginField.leadingAnchor, constant: 10),
            
            passwordWarn.heightAnchor.constraint(equalToConstant: 20),
            passwordWarn.bottomAnchor.constraint(equalTo: passwordField.topAnchor),
            passwordWarn.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor, constant: 10),
            
            confirmationWarn.heightAnchor.constraint(equalToConstant: 20),
            confirmationWarn.bottomAnchor.constraint(equalTo: confirmPassword.topAnchor),
            confirmationWarn.leadingAnchor.constraint(equalTo: confirmPassword.leadingAnchor, constant: 10)
        ])
        
        configureBackground()
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
        if !isDataValid() { return }
        
        let form = AuthEntity(login: self.loginField.text!, password: self.passwordField.text!, status: self.statusControl.selectedSegmentIndex, role: 1)

        TAFNetwork.request(router: .register(form: form)) { (result: Result<Person, Error>) in
            switch result {
            case .success(let person):
                SessionEntity.user = person
                DispatchQueue.main.async {
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "authorizied"), object: nil, userInfo: nil))
                }
            case .failure:
                let alert = UIAlertController(title: "Error", message: "Something bad with server, try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func isDataValid() -> Bool {
        guard self.confirmPassword.text != "" && self.loginField.text != "" && self.passwordField.text != "" else {
            if self.confirmPassword.text == "" {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) {
                        self.confirmationWarn.alpha = 1
                        self.confirmationWarn.text = "Shouldn't be blank"
                        self.confirmPassword.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                    }
                }
            }
            if self.loginField.text == "" {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) {
                        self.loginWarn.alpha = 1
                        self.loginWarn.text = "Shouldn't be blank"
                        self.loginField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                    }
                }
            }
            if self.passwordField.text == "" {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) {
                        self.passwordWarn.alpha = 1
                        self.passwordWarn.text = "Shouldn't be blank"
                        self.passwordField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                    }
                }
            }
            return false
        }
        
        if loginField.text?.count ?? 0 < 8 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    self.passwordWarn.alpha = 1
                    self.passwordWarn.text = "Should have at least 8 characters"
                    self.passwordField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                }
            }
            return false
        }
        
        if loginField.text != confirmPassword.text {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    self.confirmationWarn.alpha = 1
                    self.confirmationWarn.text = "Passwords should be same"
                    self.confirmPassword.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                }
            }
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        deactivate()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        deactivate()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        deactivate()
        return true
    }
    
    func deactivate() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.loginField.backgroundColor = .clear
                self.passwordField.backgroundColor = .clear
                self.confirmPassword.backgroundColor = .clear
                self.loginWarn.alpha = 0
                self.passwordWarn.alpha = 0
                self.confirmationWarn.alpha = 0
            }
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureBackground()
    }
    
    func configureBackground() {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.view.backgroundColor = .black
            self.submitButton.layer.borderColor = UIColor.white.cgColor
            self.submitButton.setTitleColor(.white, for: .normal)
            self.submitButton.setTitleColor(.darkGray, for: .highlighted)
            self.confirmationWarn.textColor = .white
            self.loginWarn.textColor = .white
            self.passwordWarn.textColor = .white
        } else {
            self.view.backgroundColor = .white
            self.submitButton.layer.borderColor = UIColor.black.cgColor
            self.submitButton.setTitleColor(.black, for: .normal)
            self.submitButton.setTitleColor(.lightGray, for: .highlighted)
            self.confirmationWarn.textColor = .black
            self.loginWarn.textColor = .black
            self.passwordWarn.textColor = .black
        }
    }
    
    
}
