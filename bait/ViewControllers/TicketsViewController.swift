//
//  TicketsViewController.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import UIKit
import MBProgressHUD

class TicketsViewController: UIViewController {
    private var tickets: [Complaints] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTickets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTickets() {
        Tickets.getTickets { result in
            MBProgressHUD.hide(for: self.view, animated: true)

            switch result {
            case .success(let tickets):
                self.tickets = tickets
                
            case .failure(let error):
                let error = error
                //Utils.showAlert(with: error, alertDelegate: self)
            }
        }
    }

}
