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

    override func viewDidLoad() {
        super.viewDidLoad()
     
        initScrollVIew()
        
        //计数器视图控件
        counterView = CounterView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        counterView.backgroundColor = UIColor.blue
        scrollView.addSubview(counterView)
        
        
        //回忆列表
        timelineView = TimelineView(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight))
 
        
        scrollView.addSubview(timelineView)
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
        print(scrollView.contentOffset.y)
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
