//
//  ListTableViewCell.swift
//  Grocery List
//
//  Created by MacBook Pro on 8/12/24.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


