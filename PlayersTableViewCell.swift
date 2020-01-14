//
//  PlayersTableViewCell.swift
//  Sports Profiling
//
//  Created by Findlay Wood on 28/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit

class PlayersTableViewCell: UITableViewCell {
    
    @IBOutlet var playerName: UILabel!
    @IBOutlet var availableButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
