//
//  CheckableTableViewCell.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/29/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

class CheckableTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        itemText.font = UIFont (name: "ReemKufi-Regular", size: 32)
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
        // Configure the view for the selected state
    }

}
