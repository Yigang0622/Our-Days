//
//  TimelineView.swift
//  Our Days
//
//  Created by Mike.Zhou on 22/08/2017.
//  Copyright © 2017 Mike.Zhou. All rights reserved.
//

import UIKit

class TimelineView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    var tableView = UITableView()
    
    //我们的回忆
    var ourMemories = [KeyMemory]()
    
    var leftPadding:CGFloat = 40
    var topPadding:CGFloat = 80

    var ourRelactionship = RelationshipManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = getScreenHeight()
        self.frame.size.width = getScreenWidth()
        
        reload()
        drawMyLabel()
    }
    
    func reload(){
        
        tableView.removeFromSuperview()
        ourRelactionship = RelationshipManager()
        ourMemories = ourRelactionship.ourMemories
        initTableView()
    }
    
    //初始化Table
    fileprivate func initTableView(){
        let width = getScreenWidth() - 2*leftPadding
        var height = CGFloat(9 * 55)
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 1792{
                height = CGFloat(12 * 55)
                topPadding = 130
            }
        }
        
        tableView = UITableView(frame: CGRect(x: leftPadding, y: topPadding, width: width, height: height))
        tableView.backgroundColor = UIColor.clear
        let nib = UINib(nibName: "MemeryTableViewCell", bundle: nil)
 
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.delegate = self
        tableView.tableFooterView = UIView()
  
        
        addSubview(tableView)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let helper = DatabaseHelper()
            helper.removeMemory(withUuid: ourMemories[indexPath.row].uuid)
            CloudManager().updateMemories()
            ourMemories.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }
    
    func drawMyLabel(){
        let label = UILabel(frame: CGRect(x: 0, y: getScreenHeight() - 60, width: getScreenWidth(), height: 50))
        label.textAlignment = .center
        label.text = "Created By Yigang with ❤️"
        label.textColor = UIColor.white
        label.alpha = 0.8
        label.font = UIFont.systemFont(ofSize: 12)
        addSubview(label)
        
    }
    
    //TableView代理方法
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ourMemories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemeryTableViewCell
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = UIColor.clear
        cell.update(withMemory: ourMemories[indexPath.row])
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
