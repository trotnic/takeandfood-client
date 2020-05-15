//
//  ViewController.swift
//  Take&Food
//
//  Created by Vladislav on 4/21/20.
//  Copyright © 2020 Uladzislau Volchyk. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var doThings: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doThings.addTarget(self, action: #selector(doFoo(responder:)), for: .touchUpInside)
        
        self.view.backgroundColor = .red
        
        // Do any additional setup after loading the view.
    }
    
    @objc func doFoo(responder: UIButton) {
        
        
    }

}

