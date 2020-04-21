//
//  LogInViewController.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import UIKit
import SVProgressHUD
import MBProgressHUD
import JWTDecode

class LogInViewController: UIViewController {
    @IBOutlet weak var emailLabe: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBAction func login(_ sender: Any) {
        guard let email = emailLabe.text, email.isValidEmail, let password = passwordLabel.text, !password.isEmpty else {
            return
        }
        
        for textField in [emailLabe, passwordLabel] {
            if textField!.canResignFirstResponder {
                textField?.resignFirstResponder()
                break
            }
        }
        
        login(email: email, password: password)
    }
    
    private func login(email: String, password: String) {
        //MBProgressHUD.showAdded(to: view, animated: true)
        
        User.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                guard let userId = self.getUserId(from: token.access) else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    SVProgressHUD.showError(withStatus: "Error al iniciar sesión.")
                    
                    return
                }
                
                self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
                
            case .failure(let error):
                let error = error
                MBProgressHUD.hide(for: self.view, animated: true)
                SVProgressHUD.showError(withStatus: "Error al iniciar sesión.")
            }
        }
    }
    
    func getUserId(from token: String) -> Int? {
        do {
            let jwt = try decode(jwt: token)
            return jwt.claim(name: "user_id").integer
        } catch {
            print(error)
            return nil
        }
        return nil
    }
    
}

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
}
