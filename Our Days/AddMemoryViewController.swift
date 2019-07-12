//
//  AddMemoryViewController.swift
//  Our Days
//
//  Created by Mike.Zhou on 22/08/2017.
//  Copyright © 2017 Mike.Zhou. All rights reserved.
//

import UIKit

class AddMemoryViewController: UIViewController,UITextFieldDelegate {
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
    var blurEffectView = UIVisualEffectView.init()
    
    var datePicker = UIDatePicker()
    var textField = UITextField()
    
    let padding:CGFloat = 40
    
    let helper = DatabaseHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)

        initBlurEffect()
        initDatePicker()
        initTextfield()
        initTitleLabel()
        initOkButton()
        
        
        showAnimation()
    }
    
    func showAnimation(){
        self.view.frame.origin.y = screenHeight
        UIView.animate(withDuration: 0.2) { 
            self.view.frame.origin.y = 0
            self.blurEffectView.alpha = 1
        }
        
    }
    
    func dismissAnimation(){
        UIView.animate(withDuration: 0.2, animations: { 
            self.view.frame.origin.y = self.screenHeight
        }) { (finished) in
            self.view.removeFromSuperview()
        }
        
        
    }
    
    func initTitleLabel(){
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: screenWidth, height: 50))
        label.text = "Add Memory"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.light)
        label.textColor = UIColor.white
        self.view.addSubview(label)
    }
    
    func initDatePicker(){
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth , height: 150))
        datePicker.datePickerMode = .date
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.center.y = self.view.center.y
        self.view.addSubview(datePicker)
        
        
    }
    
    func initTextfield(){
        textField = UITextField(frame: CGRect(x: padding, y: 200, width: screenWidth - 2*padding, height: 30))
        textField.textAlignment = .center
        textField.textColor = UIColor.white
        textField.returnKeyType = .done
        textField.delegate = self
        let line = UIView(frame: CGRect(x: textField.frame.origin.x, y: textField.frame.size.height + textField.frame.origin.y + 1, width: textField.frame.size.width, height: 2))
        line.backgroundColor = UIColor.white
        
        self.view.addSubview(line)
        self.view.addSubview(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func initOkButton(){
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setImage(UIImage(named:"icon_ok"), for: .normal)
        button.center = self.view.center
        button.center.y += 200
        button.addTarget(self, action: #selector(self.okButtonTap), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func okButtonTap(){
        let text = textField.text
        if text != "" {
            let remark = text
            let time = datePicker.date.timeIntervalSince1970
            let memory = KeyMemory()
            memory.remark = remark!
            memory.time = time
            helper.insertMemory(memory)
            CloudManager().uploadMemories()
            let notificationName = Notification.Name("synced")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        
        dismissAnimation()
    }

    
    func initBlurEffect(){
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        self.view.addSubview(blurEffectView)
    }
  

    

}
