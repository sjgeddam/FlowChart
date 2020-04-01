//
//  CalendarCollectionViewCell.swift
//  FlowChart-iOSProject
//
//  Created by Shannon Radey on 3/30/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit


class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var markDate: UIImageView!
    let curDateColor = UIColor(red: 245/255, green: 157/255, blue: 53/255, alpha: 0.6)
    
    
    
    func setDate(date: String, currentDate: Bool) {
        if date != "0" {
            dateLabel.text = date
        } else {
            dateLabel.text = " "
        }
        if (currentDate == true) {
            markDate.tintColor = curDateColor
        } else {
            markDate.tintColor = .clear
        }
    }
}
