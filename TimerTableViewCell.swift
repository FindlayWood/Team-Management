//
//  TimerTableViewCell.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 16/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell {
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
