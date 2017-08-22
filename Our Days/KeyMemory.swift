//
//  KeyMemory.swift
//  Our Days
//
//  Created by Mike.Zhou on 21/08/2017.
//  Copyright © 2017 Mike.Zhou. All rights reserved.
//

import UIKit

//回忆
class KeyMemory: NSObject {
    
    var uuid = UUID().uuidString
    
    //时间
    var time = Date().timeIntervalSince1970
    
    //备注
    var remark = ""
    
    //经历天数
    var daysPassed = 0
    
    var isRemoved = 0

    func getDaysPassed() -> Int{

        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: Date(timeIntervalSince1970: time))
        let date2 = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day!
        
        
    }
    
}
