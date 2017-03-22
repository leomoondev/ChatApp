//
//  ViewController.swift
//  ChatApp
//
//  Created by Hyung Jip Moon on 2017-03-14.
//  Copyright © 2017 leomoon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let ref = FIRDatabase.database().reference(fromURL: "https://chatapp-44ec2.firebaseio.com/")
        ref.updateChildValues(["someValue": 123123])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }

    func handleLogout() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}

