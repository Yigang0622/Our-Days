//
//  RelationshipManager.swift
//  Our Days
//
//  Created by Mike.Zhou on 22/08/2017.
//  Copyright © 2017 Mike.Zhou. All rights reserved.
//

import UIKit

class RelationshipManager: NSObject {
    
    var daysSinceTogether = 0
    var theDayThatWeAreTogether = TimeInterval()
    var ourMemories = [KeyMemory]()
    
    let helper = DatabaseHelper()
    
    override init() {
        super.init()
        theDayThatWeAreTogether = parseDate(date: "2017-08-19")
        daysSinceTogether = calculateDaysInterval()
        ourMemories = helper.realAllOurMemories().reversed()
    }

    
    func parseDate(date:String) -> TimeInterval{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600*8)
        return dateFormatter.date(from: date)!.timeIntervalSince1970
    }
    
    func calculateDaysInterval()-> Int{
//        let calendar = Calendar.current
//        let date1 = calendar.startOfDay(for: theDayThatWeAreTogether)
//        let date2 = calendar.startOfDay(for: Date())
//
//        print(theDayThatWeAreTogether)
//        let components = calendar.dateComponents([.day], from: date1, to: date2)
//        return components.day!
        return (Int)((Date().timeIntervalSince1970 - theDayThatWeAreTogether) / (3600*24))
    }
    
    
}
