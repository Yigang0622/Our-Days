//
//  CounterView.swift
//  Our Days
//
//  Created by Mike.Zhou on 21/08/2017.
//  Copyright © 2017 Mike.Zhou. All rights reserved.
//

import UIKit

class CounterView: UIView {
    
    var backgroundImg = UIImageView()
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var blurEffectView = UIVisualEffectView.init()
    
    
    var dayLabel = UILabel()
    
    var views = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = getScreenHeight()
        self.frame.size.width = getScreenWidth()
        
        backgroundImg = UIImageView(frame: frame)
        backgroundImg.image = UIImage(named: "background")
        addSubview(backgroundImg)
        initBlurEffect()
        initDayLabel()
    }
    
    func initDayLabel(){
        dayLabel = UILabel()
        dayLabel.text = "3"
        dayLabel.font = UIFont.systemFont(ofSize: 100, weight: UIFontWeightLight)
        dayLabel.sizeToFit()
        dayLabel.center = self.center
        dayLabel.textColor = UIColor.white
        dayLabel.frame.origin.y -= 120
        addSubview(dayLabel)
        applyShadow(view: dayLabel)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: getScreenWidth(), height: 25))
        imageView.image = UIImage(named: "heart")
        imageView.contentMode = .scaleAspectFit
        imageView.center = self.center
        imageView.frame.origin.y -= 50
        addSubview(imageView)
        
        let subLabel = UILabel()
        subLabel.text = "days since we are together"
        subLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
        subLabel.numberOfLines = 0
        subLabel.sizeToFit()
        subLabel.center = self.center
        subLabel.textColor = UIColor.white
        subLabel.frame.origin.y -= 20
        addSubview(subLabel)
        applyShadow(view: subLabel)
        
        views.append(dayLabel)
        views.append(imageView)
        views.append(subLabel)
    }
    
    func applyShadow(view: UIView) {
        let layer = view.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        
    }
    
    func initBlurEffect(){
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        self.addSubview(blurEffectView)
    }
    
    func changeBlurEffect(intensity:CGFloat){
        print(intensity)
        if intensity > 0.8 {
            blurEffectView.alpha = 0.8
        }else{
            blurEffectView.alpha = intensity
        }
        
        for view in views{
            view.alpha = 1 - intensity
        }
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
