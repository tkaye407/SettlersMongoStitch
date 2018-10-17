//
//  GroupsTableViewCell.swift
//  Settlers
//
//  Created by Tyler Kaye on 8/27/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var numMembers: UILabel!
    @IBOutlet weak var totalSpent: UILabel!
    @IBOutlet weak var numTransactions: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
