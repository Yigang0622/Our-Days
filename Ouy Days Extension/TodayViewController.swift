//
//  TodayViewController.swift
//  Ouy Days Extension
//
//  Created by Mike.Zhou on 06/09/2017.
//  Copyright © 2017 Mike.Zhou. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    @IBOutlet weak var dayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    

    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        dayLabel.text = String(calculateDaysInterval())
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.launchApp))
        
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func launchApp() {
        let url: URL? = URL(string: "launch:")!
        
        if let appurl = url {
            print("open url")
            self.extensionContext!.open(appurl,
                                        completionHandler: nil)
        }
    }
    
    func parseDate(date:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "zh_Hans_CN")
        return dateFormatter.date(from: date)!
    }
    
    func calculateDaysInterval()-> Int{
        
        let theDayThatWeAreTogether =  parseDate(date: "2017-08-19")
        
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: theDayThatWeAreTogether)
        let date2 = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day!
    }

    
}
