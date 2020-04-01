//
//  CustomTableViewCell.swift
//  FlowChart-iOSProject
//
//  Created by Soujanya Geddam on 4/1/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    

    @IBOutlet weak var symptom: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
