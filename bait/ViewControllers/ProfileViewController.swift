//
//  ProfileViewController.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBAction func logout(_ sender: Any) {
        
        Constants.user = nil
        Constants.isLoggedIn = false
        Constants.token = nil
        
        dismiss(animated: true, completion: nil)
    }
}
