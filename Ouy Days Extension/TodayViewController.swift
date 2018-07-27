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
    
    var ourRelationship = RelationshipManager()
    
    var tableView = UITableView()
    
    var memories = [KeyMemory]()
    
  
    var dayPercentView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dayPercentView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 110))
//        dayPercentView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//
//
        self.view.addSubview(dayPercentView)
        self.view.sendSubview(toBack: dayPercentView)
        
//        dayPercentView.frame.size.width = CGFloat(getDayTimePercentage()) * self.view.frame.size.width

        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .compact
    
        }else{
            
            //compatible for iOS 9
            let width:Int = Int(self.view.frame.size.width)
            self.preferredContentSize = CGSize(width: width, height: 110)
        }
     
    }
    
    func getDayTimePercentage() -> Double{
        var secondCount = (Int)(Date().timeIntervalSince1970)
        secondCount += 3600*8
        let secondScienceToday = secondCount % (3600*24)
        let percentage =   (Double)(secondScienceToday) / (3600.0*24.0)
        return percentage
    }
    
//    func initTableView(){
//
//        tableView.removeFromSuperview()
//
//        let width = self.view.frame.size.width - 30
//
//        tableView = UITableView(frame: CGRect(x: 15, y: 120, width: width, height: 200))
//
//        let nib = UINib(nibName: "TableViewCell", bundle: nil)
//
//        tableView.register(nib, forCellReuseIdentifier: "cell")
//
//        tableView.dataSource = self
//        tableView.showsVerticalScrollIndicator = false
//        tableView.bounces = false
//        tableView.delegate = self
//
//
//        self.view.addSubview(tableView)
//        tableView.reloadData()
//
//    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if (activeDisplayMode == .compact){
            self.preferredContentSize = maxSize;
        }
        else{
           // initTableView()
            self.preferredContentSize = CGSize( width: 300, height: 300)
        
        }
    }
    

    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        ourRelationship = RelationshipManager()

        dayLabel.text = String(ourRelationship.daysSinceTogether)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.launchApp))
        
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
        
//        dayPercentView.frame.size.width = CGFloat(getDayTimePercentage()) * self.view.frame.size.width
        
        completionHandler(NCUpdateResult.newData)
    }
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return memories.count
//    }
//
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
//        print("cell")
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 45
//    }
//
    func launchApp() {
        let url: URL? = URL(string: "launch:")!
        
        if let appurl = url {
            print("open url")
            self.extensionContext!.open(appurl,
                                        completionHandler: nil)
        }
    }
    


    
}
