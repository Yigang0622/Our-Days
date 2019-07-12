//
//  DatabaseHelper.swift
//  Our Days
//
//  Created by Mike.Zhou on 22/08/2017.
//  Copyright © 2017 Mike.Zhou. All rights reserved.
//

import UIKit
import SQLite

class DatabaseHelper: NSObject {
    
    fileprivate var db:Connection!
    fileprivate var ourMemory:Table!

    fileprivate let id = Expression<Int64>("id")
    
    fileprivate let uuid = Expression<String>("uuid")
    fileprivate let remark = Expression<String>("remark")
    fileprivate let timeStamp = Expression<Int64>("timeStamp")
    fileprivate let isRemoved = Expression<Int64>("isRemoved")
    
    fileprivate let mCKRecord = Expression<String>("ckrecord")
    fileprivate let needUpdate = Expression<Int>("need_update")
    
    override init() {
        
        super.init()

        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
   
        do {
            db = try Connection("\(path)/db.sqlite3")
        } catch {
            print(error.localizedDescription)
        }
        
        ourMemory  = Table("our_memory")
        
        
        do {
            
            try db.run(ourMemory.create(ifNotExists: true) {t in
                t.column(id, primaryKey: .autoincrement)
                t.column(uuid, unique: true)
                t.column(remark)
                t.column(timeStamp)
                t.column(mCKRecord, defaultValue: "")
                t.column(isRemoved,defaultValue: 0)
                t.column(needUpdate,defaultValue: 0)
            })
            
        } catch {
            print(error)
        }

    }
    
    
    func insertMemory(_ memory: KeyMemory)  {
        
        do{
            try db.run(ourMemory.insert(or: .replace,
                                      uuid <- memory.uuid,
                                      remark <- memory.remark,
                                      timeStamp <- Int64(memory.time),
                                      isRemoved <- Int64(memory.isRemoved)
            ))
            
            print("Memory \(memory.uuid) inserted")
        }catch{
            print(error)
        }
        saveMemoryToUserDefault()
    }
    
    func markMemoryAsUpload(withUUID:String,ckRecordID:String){
        let memory = ourMemory.filter(uuid == withUUID)
        do{
            try db.run(memory.update(mCKRecord <- ckRecordID))
            try db.run(memory.update(needUpdate <- 0))
        }catch{
            print(error)
        }
    }
    
    func readMemoriesForUpload() -> [KeyMemory]{
        var arr = Array<KeyMemory>()
        
        do{
            let temp = ourMemory.filter(mCKRecord == "").order(timeStamp.asc)
            for memory in try db.prepare(temp) {
                
                let bean = KeyMemory()
                bean.uuid = memory[uuid]
                bean.time = TimeInterval(memory[timeStamp])
                bean.remark = memory[remark]
                bean.isRemoved = Int(memory[isRemoved])
                arr.append(bean)
            }
        }catch{
            print(error.localizedDescription)
        }
        return arr
    }
    
    func saveMemoryToUserDefault(){
        let memory = realAllOurMemories()
        let userDefault = UserDefaults.standard
        
        var titleArr = [String]()
        var dateArr = [Int64]()
        
        for each in memory {
            if each.isRemoved == 0 {
                titleArr.append(each.remark)
                dateArr.append(Int64(each.time))
            }
        }
        
        userDefault.set(titleArr, forKey: "memoryTitle")
        userDefault.set(dateArr, forKey: "memoryDate")
        
    }
    
    func readMemoryFromUserDefault(){
        let userDefault = UserDefaults.standard
        let arr = userDefault.array(forKey: "memoryTitle")
        
        print(arr?.count as Any,"awfaef")
        
    }
    
 
    func removeMemory(withUuid:String){
        
        let memory = ourMemory.filter(uuid == withUuid)
        do{
            
            for each in try db.prepare(memory){
                if each[mCKRecord] == "" { //not upload yet
                    try db.run(memory.delete())
                }else{
                    try db.run(memory.update(needUpdate <- 1))
                    try db.run(memory.update(isRemoved <- 1))
                }
            }
            
        }catch{
            print(error)
        }
        saveMemoryToUserDefault()
    }
    
    func readIDforRemove() -> [String]{
        var arr = Array<String>()
        
        do{
            let temp = ourMemory.filter(isRemoved == 1 && mCKRecord != "").order(timeStamp.asc)
            for memory in try db.prepare(temp) {
                arr.append(memory[mCKRecord])
            }
        }catch{
            print(error.localizedDescription)
        }
        return arr
    }
    
    
    func realAllOurMemories() -> [KeyMemory]{
        var arr = Array<KeyMemory>()
        
        do{
            let temp = ourMemory.filter(isRemoved == 0).order(timeStamp.asc)
            for memory in try db.prepare(temp) {
                
                let bean = KeyMemory()
                bean.uuid = memory[uuid]
                bean.time = TimeInterval(memory[timeStamp])
                bean.remark = memory[remark]
                bean.isRemoved = Int(memory[isRemoved])
                arr.append(bean)
            }
        }catch{
            print(error.localizedDescription)
        }
        return arr

    }
    
    
}
