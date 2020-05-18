//
//  PersonEditController.swift
//  Take&Food
//
//  Created by Vladislav on 5/18/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit

class PersonEditController: UIViewController, UITextFieldDelegate {

    
    let nameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tag = 0
        field.placeholder = "Enter new name"
        field.borderStyle = .roundedRect
        field.text = SessionEntity.user.name
        return field
    }()
    
    let emailField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tag = 1
        field.placeholder = "Enter new email"
        field.borderStyle = .roundedRect
        field.keyboardType = .emailAddress
        field.text = SessionEntity.user.email
        field.autocapitalizationType = .none
        return field
    }()
    
    let statusControl: UISegmentedControl = {
        let stepper = UISegmentedControl()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.insertSegment(withTitle: "Student", at: 0, animated: true)
        stepper.insertSegment(withTitle: "Employee", at: 1, animated: true)
        stepper.insertSegment(withTitle: "Jobless", at: 2, animated: true)
        stepper.selectedSegmentIndex = SessionEntity.user.status ?? 0
        return stepper
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    let nameWarn: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .black
        label.backgroundColor = .clear
        label.alpha = 0
        return label
    }()

    let emailWarn: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .black
        label.backgroundColor = .clear
        label.alpha = 0
        return label
    }()

    let statusSup: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .black
        label.backgroundColor = .clear
        label.text = "Social status"
        return label
    }()

    
    override func loadView() {
        super.loadView()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Edit"
        self.nameField.delegate = self
        self.emailField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(statusControl)
        view.addSubview(saveButton)
        view.addSubview(nameWarn)
        view.addSubview(emailWarn)
        view.addSubview(statusSup)
        
        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameField.heightAnchor.constraint(equalToConstant: 40),
            
            emailField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            emailField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 30),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            
            statusControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            statusControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            statusControl.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 30),
            statusControl.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            saveButton.topAnchor.constraint(equalTo: statusControl.bottomAnchor, constant: 30),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            nameWarn.heightAnchor.constraint(equalToConstant: 20),
            nameWarn.bottomAnchor.constraint(equalTo: nameField.topAnchor),
            nameWarn.leadingAnchor.constraint(equalTo: nameField.leadingAnchor, constant: 10),
            
            emailWarn.heightAnchor.constraint(equalToConstant: 20),
            emailWarn.bottomAnchor.constraint(equalTo: emailField.topAnchor),
            emailWarn.leadingAnchor.constraint(equalTo: emailField.leadingAnchor, constant: 10),
            
            statusSup.heightAnchor.constraint(equalToConstant: 20),
            statusSup.bottomAnchor.constraint(equalTo: statusControl.topAnchor),
            statusSup.leadingAnchor.constraint(equalTo: statusControl.leadingAnchor, constant: 10),
        ])

        configureBackground()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureBackground()
    }
    
    func configureBackground() {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.view.backgroundColor = .black
            self.saveButton.layer.borderColor = UIColor.white.cgColor
            self.saveButton.setTitleColor(.white, for: .normal)
            self.saveButton.setTitleColor(.darkGray, for: .highlighted)
            self.nameWarn.textColor = .white
            self.emailWarn.textColor = .white
            self.statusSup.textColor = .white
        } else {
            self.view.backgroundColor = .white
            self.saveButton.layer.borderColor = UIColor.black.cgColor
            self.saveButton.setTitleColor(.black, for: .normal)
            self.saveButton.setTitleColor(.lightGray, for: .highlighted)
            self.nameWarn.textColor = .black
            self.emailWarn.textColor = .black
            self.statusSup.textColor = .black
        }
    }

    @objc func save() {
        if !isValidData() { return }
        let person = Person(
            id: SessionEntity.user.id,
            name: self.nameField.text,
            login: SessionEntity.user.login,
            password: SessionEntity.user.password,
            email: self.emailField.text,
            restaurantId: SessionEntity.user.restaurantId,
            role: SessionEntity.user.role,
            status: statusControl.selectedSegmentIndex
        )
        
        TAFNetwork.request(router: .updatePerson(form: person)) { (result: Result<Person, Error>) in
            switch result {
            case .success(let person):
                DispatchQueue.main.async {
                    SessionEntity.user = person
                }
                self.navigationController?.popViewController(animated: true)
            case .failure:
                let alert = UIAlertController(title: "Error", message: "Something went wrong, please, check input data", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func isValidData() -> Bool {
        guard self.nameField.text != "" && self.emailField.text != "" else {
            if self.nameField.text == "" {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) {
                        self.nameWarn.alpha = 1
                        self.nameWarn.text = "Shouldn't be blank"
                        self.nameField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                    }
                }
            }
            if self.emailField.text == "" {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) {
                        self.emailWarn.alpha = 1
                        self.emailWarn.text = "Shouldn't be blank"
                        self.emailField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                    }
                }
            }
            
            return false
        }
        
        if !isValidEmail(self.emailField.text) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    self.emailWarn.alpha = 1
                    self.emailWarn.text = "Invalid email"
                    self.emailField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                }
            }
            return false
        }
        
        return true
        
        
    }
    
    func isValidEmail(_ email: String?) -> Bool {
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
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
                self.nameField.backgroundColor = .clear
                self.emailField.backgroundColor = .clear
                self.nameWarn.alpha = 0
                self.emailWarn.alpha = 0
            }
        }
    }
}
