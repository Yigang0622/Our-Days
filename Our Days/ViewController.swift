//
//  ViewController.swift
//  Our Days
//
//  Created by Mike.Zhou on 21/08/2017.
//  Copyright © 2017 Mike.Zhou. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UIScrollViewDelegate {
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var scrollView = UIScrollView()
    
    var counterView = CounterView()
    
    var timelineView = TimelineView()
    
    var ourRelationship = RelationshipManager()

    let notificationName = Notification.Name("synced")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onSynced), name: notificationName, object: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootController = self
        
        
        initScrollVIew()
        
        //计数器视图控件
        counterView = CounterView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        counterView.setDay(day: ourRelationship.daysSinceTogether)
        counterView.button.addTarget(self, action: #selector(self.addMemory), for: .touchUpInside)
        scrollView.addSubview(counterView)
        
        
        //回忆列表
        timelineView = TimelineView(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight))
 
        scrollView.addSubview(timelineView)
        
        CloudManager().sync()
    }
    
    func update(){
        UIView.animate(withDuration: 0.2, animations: { 
            self.scrollView.contentOffset.y = 0
        }, completion: nil)
        ourRelationship = RelationshipManager()
        counterView.setDay(day: ourRelationship.daysSinceTogether)
        timelineView.reload()
    }
    
    func onSynced(){
        timelineView.reload()
        
    }

    func addMemory(){
        let controller = AddMemoryViewController()
        self.addChildViewController(controller)
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        self.view.bringSubview(toFront: controller.view)
        controller.didMove(toParentViewController:  self)
        
    }
    

    func initScrollVIew(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: screenWidth, height: 2 * screenHeight)
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let verticalOffset = scrollView.contentOffset.y
        counterView.frame.origin.y = verticalOffset
        
        let blurIntensity =  verticalOffset / screenHeight
        counterView.changeBlurEffect(intensity: blurIntensity)
    }
    
}

extension UIView{
    func getScreenHeight()->CGFloat{
        return UIScreen.main.bounds.height
    }
    
    func getScreenWidth()-> CGFloat{
        return UIScreen.main.bounds.width
    }

}
