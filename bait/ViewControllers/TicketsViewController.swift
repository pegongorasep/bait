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
    
    var pagination: PaginationInfo?
    var isFetchingData = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        ticketsTableView.dataSource = self
        ticketsTableView.delegate = self
        
        ticketsTableView.register(UINib(nibName: "TicketCell", bundle: nil), forCellReuseIdentifier: "TicketCell")
        ticketsTableView.allowsSelection = true
        
        refreshControl.addTarget(self, action: #selector (loadTickets), for: .valueChanged)
        ticketsTableView.addSubview(refreshControl)
        
        self.refreshControl.beginRefreshing()
        pagination = PaginationInfo(currentPage: 1, nextPage: 2, hasMoreItems: false)
        loadTickets(page: 1)
    }
    
    @objc func loadTickets(page: Int) {
        isFetchingData = true
        
        Tickets.getTickets(page: page) { result in
            self.refreshControl.endRefreshing()
            self.isFetchingData = false

            switch result {
            case .success(let tickets):
                if tickets.complaints.count > 0 {
                    
                    if tickets.complaints.count > 9 {
                        self.pagination?.hasMoreItems = true
                    }
                    self.pagination?.currentPage = page
                    self.pagination?.nextPage = page + 1
                    
                    if page > 1 {
                        self.tickets?.complaints.append(contentsOf: tickets.complaints)
                    } else {
                        self.tickets = tickets
                    }
                    
                } else {
                    self.pagination!.hasMoreItems = false
                }
                
                                
                DispatchQueue.main.async {
                    self.ticketsTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension TicketsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets?.complaints.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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

extension TicketsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.scrollsToTop && scrollView.contentOffset.y > 1.0 {
            guard !isFetchingData, let pagination = pagination, pagination.hasMoreItems else { return }
            
            self.ticketsTableView.tableFooterView?.isHidden = false
            loadTickets(page: pagination.nextPage)
        }
    }
}
