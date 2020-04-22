//
//  AnouncementsViewController.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import UIKit

class AnouncementsViewController: UIViewController {
        private var anouncements: Anouncements?
        @IBOutlet weak var announcementsTableView: UITableView!
        private let refreshControl = UIRefreshControl()
        
        var pagination: PaginationInfo?
        var isFetchingData = false
    
        override func viewDidLoad() {
            super.viewDidLoad()

            announcementsTableView.dataSource = self
            announcementsTableView.delegate = self
            
            announcementsTableView.register(UINib(nibName: "TicketCell", bundle: nil), forCellReuseIdentifier: "TicketCell")
            announcementsTableView.allowsSelection = true
            
            refreshControl.addTarget(self, action: #selector (loadAnouncementsStart), for: .valueChanged)
            announcementsTableView.addSubview(refreshControl)
                        
            pagination = PaginationInfo(currentPage: 1, nextPage: 2, hasMoreItems: false)
            loadAnouncements(page: 1)
        }
    
    @objc func loadAnouncementsStart() {
        loadAnouncements(page: 1)
    }
        
    @objc func loadAnouncements(page: Int = 1) {
            self.refreshControl.beginRefreshing()
            isFetchingData = true

        Anouncements.getAnouncements(page: page) { result in
                self.refreshControl.endRefreshing()
                self.isFetchingData = false

                switch result {
                case .success(let tickets):
                    if tickets.bulletins.count > 0 {
                        
                        if tickets.bulletins.count > 9 {
                            self.pagination?.hasMoreItems = true
                        }
                        self.pagination?.currentPage = page
                        self.pagination?.nextPage = page + 1
                        
                        if page > 1 {
                            self.anouncements?.bulletins.append(contentsOf: tickets.bulletins)
                        } else {
                            self.anouncements = tickets
                        }
                        
                    } else {
                        self.pagination!.hasMoreItems = false
                    }
                    
                    DispatchQueue.main.async {
                        self.announcementsTableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    extension AnouncementsViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return anouncements?.bulletins.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.announcementsTableView.dequeueReusableCell(withIdentifier: "TicketCell") as! TicketCell
            let announcement = anouncements?.bulletins[indexPath.row]
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.locale = .init(identifier: "es_ES")
            dateFormatterPrint.dateFormat = "EEEE d, MMMM yyyy"

            if let date = dateFormatterGet.date(from: announcement!.created_at) {
                cell.dateLabel.text = dateFormatterPrint.string(from: date)
            } else {
               cell.dateLabel.text = "error"
            }
            
            cell.descriptionLabel.text = announcement?.message
            cell.statusLabel.alpha = 0
            cell.statusColorLabel.alpha = 0
            
            return cell
        }
    }

extension AnouncementsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.scrollsToTop && scrollView.contentOffset.y > 1.0 {
            guard !isFetchingData, let pagination = pagination, pagination.hasMoreItems else { return }
            
            self.announcementsTableView.tableFooterView?.isHidden = false
            loadAnouncements(page: pagination.nextPage)
        }
    }
}
