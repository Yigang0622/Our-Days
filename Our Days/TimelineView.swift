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
    
    let leftPadding:CGFloat = 40
    let topPadding:CGFloat = 80

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = getScreenHeight()
        self.frame.size.width = getScreenWidth()
        initTableView()
        drawMyLabel()
    }
    
    //初始化Table
    fileprivate func initTableView(){
        let width = getScreenWidth() - 2*leftPadding
        let height = CGFloat(9 * 55)
        
        tableView = UITableView(frame: CGRect(x: leftPadding, y: topPadding, width: width, height: height))
        tableView.backgroundColor = UIColor.clear
        let nib = UINib(nibName: "MemeryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsetsMake(0,0,0,0)
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        for _ in 0...17{
            ourMemories.append(KeyMemory())
        }
        
        addSubview(tableView)
        tableView.reloadData()
        
    }
    
    func drawMyLabel(){
        let label = UILabel(frame: CGRect(x: 0, y: getScreenHeight() - 60, width: getScreenWidth(), height: 50))
        label.textAlignment = .center
        label.text = "Develped By Yigang with ❤️"
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

        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
