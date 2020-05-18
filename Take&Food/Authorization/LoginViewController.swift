//
//  LoginViewController.swift
//  Take&Food
//
//  Created by Vladislav on 5/15/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var loginField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Enter login"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        return field
    }()
    
    var passwordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Enter password"
        field.isSecureTextEntry = true
        field.autocapitalizationType = .none
        field.borderStyle = .roundedRect
        return field
    }()
    
    var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Sign in", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        return button
    }()
    
    var passwordWarn: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .black
        label.backgroundColor = .clear
        label.alpha = 0
        return label
    }()
    
    var loginWarn: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        
        label.backgroundColor = .clear
        label.alpha = 0
        return label
    }()

    var loginWarnConstraints: [NSLayoutConstraint] = { return [] }()
    var passwordWarnConstraints: [NSLayoutConstraint] = { return [] }()
    
    override func loadView() {
        super.loadView()
        
        loginWarn.text = "Login should have only letters"
        passwordWarn.text = "Password should have at least 8 characters"
        
        loginField.delegate = self
        passwordField.delegate = self
        
        loginField.tag = 0
        passwordField.tag = 1
        loginWarn.tag = 2
        passwordWarn.tag = 3
        
        submitButton.addTarget(self, action: #selector(submitData), for: .touchUpInside)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Sign in"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.hideKeyboardWhenTappedAround()
        
        view.addSubview(loginField)
        view.addSubview(passwordField)
        view.addSubview(submitButton)
        view.addSubview(loginWarn)
        view.addSubview(passwordWarn)
        
        NSLayoutConstraint.activate([
            loginField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loginField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            loginField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            loginField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 30),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            loginWarn.heightAnchor.constraint(equalToConstant: 20),
            loginWarn.bottomAnchor.constraint(equalTo: loginField.topAnchor),
            loginWarn.leadingAnchor.constraint(equalTo: loginField.leadingAnchor, constant: 10),
            
            passwordWarn.heightAnchor.constraint(equalToConstant: 20),
            passwordWarn.bottomAnchor.constraint(equalTo: passwordField.topAnchor),
            passwordWarn.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor, constant: 10)
        ])
        
        configureBackground()
    }
    

    @objc func submitData() {
        guard loginField.text != "" && passwordField.text != "" else {
            if loginField.text == "" {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) {
                        self.loginWarn.alpha = 1
                        self.loginField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                        self.loginWarn.text = "Shouldn't be blank"
                    }
                }
            }
            if passwordField.text == "" {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) {
                        self.passwordWarn.alpha = 1
                        self.passwordField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                        self.passwordWarn.text = "Shouldn't be blank"
                    }
                }
            }
            return
        }
        
        guard let login = loginField.text else {
            return
        }
        
        guard let password = passwordField.text else {
            return
        }
        
        if password.count < 8 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    
                    self.passwordWarn.alpha = 1
                    self.passwordField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                    self.passwordWarn.text = "Should have at least 8 characters"
                }
            }
        }
        
        let data = AuthEntity(login: login, password: password, status: nil, role: nil)
        
        
        TAFNetwork.request(router: .login(form: data)) { (result: Result<Person, Error>) in
            switch result {
            case .success(let data):
                SessionEntity.user = data
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "authorizied"), object: nil)
                }
            case .failure:
                let alert = UIAlertController(title: "Error", message: "Invalid login or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
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
            self.loginWarn.textColor = .white
            self.passwordWarn.textColor = .white
        } else {
            self.view.backgroundColor = .white
            self.submitButton.layer.borderColor = UIColor.black.cgColor
            self.submitButton.setTitleColor(.black, for: .normal)
            self.submitButton.setTitleColor(.lightGray, for: .highlighted)
            self.loginWarn.textColor = .black
            self.passwordWarn.textColor = .black
        }
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
                self.loginWarn.alpha = 0
                self.passwordWarn.alpha = 0
            }
        }
    }
}
