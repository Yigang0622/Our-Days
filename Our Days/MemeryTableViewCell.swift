//
//  MemeryTableViewCell.swift
//  Our Days
//
//  Created by Mike.Zhou on 21/08/2017.
//  Copyright © 2017 Mike.Zhou. All rights reserved.
//

import UIKit

class MemeryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = UIColor.clear.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
