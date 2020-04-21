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
    private var tickets: Complaints?
    @IBOutlet weak var ticketsTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ticketsTableView.dataSource = self
        ticketsTableView.delegate = self
        
        ticketsTableView.register(UINib(nibName: "TicketCell", bundle: nil), forCellReuseIdentifier: "TicketCell")
        ticketsTableView.allowsSelection = true
        
        refreshControl.addTarget(self, action: #selector (loadTickets), for: .valueChanged)
        ticketsTableView.addSubview(refreshControl)
        
        self.refreshControl.beginRefreshing()
        loadTickets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadTickets() {
        Tickets.getTickets { result in
            self.refreshControl.endRefreshing()

            switch result {
            case .success(let tickets):
                self.tickets = tickets
                
                DispatchQueue.main.async {
                    self.ticketsTableView.reloadData()
                }
                
            case .failure(let error):
                let error = error
                //Utils.showAlert(with: error, alertDelegate: self)
            }
        }
    }
}

extension TicketsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets?.complaints.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ticketsTableView.dequeueReusableCell(withIdentifier: "TicketCell") as! TicketCell
        let ticket = tickets?.complaints[indexPath.row]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = .init(identifier: "es_ES")
        dateFormatterPrint.dateFormat = "EEEE d, MMMM yyyy"

        if let date = dateFormatterGet.date(from: ticket!.created_at) {
            cell.dateLabel.text = dateFormatterPrint.string(from: date)
        } else {
           cell.dateLabel.text = "error"
        }
        
        cell.descriptionLabel.text = ticket?.description
        cell.statusLabel.text = ticket?.complaint_state.name
        let color = UIColor(hex: ( (ticket?.complaint_state.color) ?? "#00000000") + "FF")
        cell.statusColorLabel.backgroundColor = color
        
        return cell
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
