//
//  PostCellTableViewCell.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/2/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import UIKit

class PostCellTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    
    
    @IBOutlet weak var labelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}


