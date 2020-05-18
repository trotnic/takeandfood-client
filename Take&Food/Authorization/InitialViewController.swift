//
//  InitialViewController.swift
//  Take&Food
//
//  Created by Vladislav on 5/17/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("sign in", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("sign up", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func loadView() {
        super.loadView()
        
        loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 80),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            registerButton.heightAnchor.constraint(equalToConstant: 40),
            registerButton.widthAnchor.constraint(equalToConstant: 80)
        ])

        configureBackground()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureBackground()
    }
    
    func configureBackground() {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.view.backgroundColor = .black
            self.loginButton.setTitleColor(.white, for: .normal)
            self.registerButton.setTitleColor(.white, for: .normal)
            self.loginButton.layer.borderColor = UIColor.white.cgColor
            self.registerButton.layer.borderColor = UIColor.white.cgColor
        } else {
            self.view.backgroundColor = .white
            self.loginButton.setTitleColor(.black, for: .normal)
            self.registerButton.setTitleColor(.black, for: .normal)
            self.loginButton.layer.borderColor = UIColor.black.cgColor
            self.registerButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    
    @objc func signIn() {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
        return
    }
    
    @objc func signUp() {
        self.navigationController?.pushViewController(RegistrationViewController(), animated: true)
        return
    }
}
