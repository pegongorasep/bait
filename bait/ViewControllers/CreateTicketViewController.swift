//
//  CreateTicketViewController.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVProgressHUD

class CreateTicketViewController: UIViewController {
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var picture: UIImageView!
    @IBAction func sendTicket(_ sender: Any) {
        if let title = titleLabel.text, !title.isEmpty, let description = descriptionLabel.text, !description.isEmpty, let condominium_id = Constants.user?.user.tenant?.house?.condominium_id, let user_id = Constants.user?.user.id {
                
                MBProgressHUD.showAdded(to: view, animated: true)
                Tickets.createTicket(title: title, description: description, condominium_id: String(condominium_id), user_id: String(user_id), image: "") { [weak self] result in
                    
                    guard let self = self else { return }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print(result)
                    
                    switch result {
                    case .success( _):
                            SVProgressHUD.showSuccess(withStatus: "Ticket creado con éxito")
                            self.navigationController?.popViewController(animated: true)
                            
                        case .failure(let error):
                            SVProgressHUD.showError(withStatus: "Error al crear ticket")
                            print(error)
                    }
                }
            
        } else {
            SVProgressHUD.showError(withStatus: "Datos no válidos")
        }
    }
    
    deinit {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Constants.setNavigationTitle(of: self, with: "Crear ticket de ayuda")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addImage))
        picture.addGestureRecognizer(tap)
        picture.isUserInteractionEnabled = true
    }
    
    @objc func addImage() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = .camera
        imgPicker.allowsEditing = false
        imgPicker.showsCameraControls = true
        self.present(imgPicker, animated: true, completion: nil)
    }
    

}

extension CreateTicketViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.picture.image = img
            self.dismiss(animated: true, completion: nil)
        } else {
            print("error")
        }
    }
}
