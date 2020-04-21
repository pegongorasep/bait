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

class LogInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailLabe: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBAction func login(_ sender: Any) {
        guard let email = emailLabe.text, email.isValidEmail, let password = passwordLabel.text, !password.isEmpty else {
            SVProgressHUD.showError(withStatus: "Ingresa un usuario y contraseña")
            return
        }
        
        login(email: email, password: password)
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           #if DEBUG
               emailLabe.text = "prueba@dacodes.com.mx"
               passwordLabel.text = "dacodes2020"
           #endif

       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailLabe {
            textField.resignFirstResponder()
            passwordLabel.becomeFirstResponder()
        } else if textField == passwordLabel {
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func login(email: String, password: String) {
        //MBProgressHUD.showAdded(to: view, animated: true)
        
        User.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                if let token = user.token {
                    APIManager.shared.sessionManager.adapter = TokenAdapter(accessToken: token)
                }
                self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
                return
                
            case .failure(let error):
                _ = error
                SVProgressHUD.showError(withStatus: "Error al iniciar sesión.")
            }
        }
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
