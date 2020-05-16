//
//  LoginViewController.swift
//  Take&Food
//
//  Created by Vladislav on 5/15/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var loginField: UITextField
    var passwordField: UITextField
    var submitButton: UIButton
    var passwordWarn: UILabel
    var loginWarn: UILabel

    var loginWarnConstraints: [NSLayoutConstraint]
    var passwordWarnConstraints: [NSLayoutConstraint]
    
    init() {
        passwordWarn = UILabel()
        loginWarn = UILabel()
        loginField = UITextField()
        passwordField = UITextField()
        submitButton = UIButton()
        loginWarnConstraints = []
        passwordWarnConstraints = []
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        loginWarnConstraints = [
            loginWarn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loginWarn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            loginWarn.heightAnchor.constraint(equalToConstant: 30),
            loginWarn.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 5)
        ]
        passwordWarnConstraints = [
            passwordWarn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            passwordWarn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            passwordWarn.heightAnchor.constraint(equalToConstant: 30),
            passwordWarn.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 5)
        ]
        
        loginWarn.text = "Login should have only letters"
        passwordWarn.text = "Password should have at least 8 characters"
        
        loginField.delegate = self
        passwordField.delegate = self
        
        loginField.tag = 0
        passwordField.tag = 1
        loginWarn.tag = 2
        passwordWarn.tag = 3
        
        passwordField.isSecureTextEntry = true
        loginField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        loginWarn.translatesAutoresizingMaskIntoConstraints = false
        passwordWarn.translatesAutoresizingMaskIntoConstraints = false
        
        submitButton.addTarget(self, action: #selector(submitData), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginField)
        view.addSubview(passwordField)
        view.addSubview(submitButton)
        view.addSubview(loginWarn)
        view.addSubview(passwordWarn)
        loginField.borderStyle = .roundedRect
        passwordField.borderStyle = .roundedRect
        loginField.placeholder = "login"
        passwordField.placeholder = "password"
        self.loginWarn.alpha = 0
        self.passwordWarn.alpha = 0
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.systemGray2, for: .normal)
        NSLayoutConstraint.activate([
            loginField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loginField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            loginField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            loginField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 50),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    

    @objc func submitData() {
        guard let login = loginField.text else {
            return
        }
        guard let password = passwordField.text else {
            return
        }
        if password.count < 8 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    NSLayoutConstraint.activate(self.passwordWarnConstraints + self.loginWarnConstraints)
                    self.loginWarn.alpha = 1
                    self.passwordWarn.alpha = 1
                    self.passwordField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                }
            }
        }
        
        let data = AuthEntity(login: login, password: password, status: nil, role: nil)
        
//        TAFNetwork.request(router: .login(form: data)) { (result: Result<Person, Error>) in
//            switch result {
//            case .success(let data):
//                print(data)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        
        let router = TAFRouter.login(form: MockupData.authUser)
        var components = URLComponents()
        components.host = router.host
        components.scheme = router.scheme
        components.path = router.path
        components.queryItems = router.components
        components.port = router.port
        let url = components.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        urlRequest.httpBody = router.body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                return
            }

            guard let response = response as? HTTPURLResponse else { return }
            
            guard let data = try? JSONDecoder().decode(Person.self, from: data!) else { return }
            
            if (response.statusCode == 200) {
                UserDefaults.standard.set(true, forKey: "status")
                SessionEntity.user = data
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "loggedIn"), object: nil)
                }
                return
            }
//            print(response.statusCode)
//            let responseObject = try! JSONDecoder().decode(AuthEntity.self, from: data)
        }.resume()
    }

    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        deactivate(textField: textField)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        deactivate(textField: textField)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        deactivate(textField: textField)
        return true
    }
    
    func deactivate(textField: UITextField) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                NSLayoutConstraint.deactivate(self.passwordWarnConstraints + self.loginWarnConstraints)
                textField.backgroundColor = .clear
                self.loginWarn.alpha = 0
                self.passwordWarn.alpha = 0
            }
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
