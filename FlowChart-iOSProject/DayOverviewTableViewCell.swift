//
//  DayOverviewTableViewCell.swift
//  FlowChart-iOSProject
//
//  Created by Shannon Radey on 4/1/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

class DayOverviewTableViewCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    
    
    func setLabel(text: String) {
        cellLabel.text = "  \(text)"
        cellLabel.layer.cornerRadius = 17
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
