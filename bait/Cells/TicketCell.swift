//
//  TicketCell.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//
import UIKit

class TicketCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusColorLabel: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        statusColorLabel.backgroundColor = UIColor.red
        statusColorLabel.layer.cornerRadius = 8.0
        statusColorLabel.clipsToBounds = true
        
        arrowImage.image = arrowImage.image?.withRenderingMode(.alwaysTemplate)
        arrowImage.tintColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
