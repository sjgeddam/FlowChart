//
//  ArticleTableViewCell.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/31/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    var viewTappedAction : ((UITableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     
    @IBAction func buttonPressed(_ sender: Any) {
        viewTappedAction?(self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
