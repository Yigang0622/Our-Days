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
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(withMemory:KeyMemory){
        remarkLabel.text = withMemory.remark
        dayLabel.text = String(withMemory.getDaysPassed())
        dateLabel.text = getTimelabel(memory: withMemory)
    } 
    
    func getTimelabel(memory:KeyMemory) -> String{
        
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.day,.month,.year], from: Date(timeIntervalSince1970:memory.time))
        let monthes = ["Janauary","February","March","April","May","June","July","August","September","October","November","December"]
        return String(comp.day!) + " " + monthes[comp.month!-1] + ", " + String(comp.year!)
        
        
    }
    
}
