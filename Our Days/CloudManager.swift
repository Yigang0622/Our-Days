//
//  CloudManager.swift
//  Our Days
//
//  Created by Mike.Zhou on 22/08/2017.
//  Copyright © 2017 Mike.Zhou. All rights reserved.
//

import UIKit
import CloudKit

class CloudManager: NSObject {
    
    fileprivate let database =  CKContainer.default().publicCloudDatabase
    
    fileprivate let helper = DatabaseHelper()
    
    let notificationName = Notification.Name("synced")
    
    func sync(){
        uploadMemories()
        updateMemories()
        downloadMemories()
        
    }
    
    func uploadMemories(){
        
        let memories = helper.readMemoriesForUpload()
        
        for memory in memories {
            let timeStamp = Int64(Date(timeIntervalSince1970: memory.time).timeIntervalSince1970)
            let remark = memory.remark
            let isRemoved = memory.isRemoved
            let uuid = memory.uuid
        
            let id = (UIDevice.current.identifierForVendor?.uuidString)! + "t" + String(Date().timeIntervalSince1970)
            let recordID = CKRecordID(recordName: id)
            let record = CKRecord(recordType: "OurMemory", recordID: recordID)
            
            record["timeStamp"] = timeStamp as CKRecordValue
            record["remark"] = remark as CKRecordValue
            record["uuid"] = uuid as CKRecordValue
            record["isRemoved"] = isRemoved as CKRecordValue
            
            database.save(record) { (record, error) in
                if (error != nil) {
                    print("creatRecord failure！\n",error?.localizedDescription)
 
                } else {
                    print("creatRecord success！",record?.recordID)
                    self.helper.markMemoryAsUpload(withUUID: uuid, ckRecordID: (record?.recordID.recordName)!)
                    DispatchQueue.main.async() {
                        //NotificationCenter.default.post(name: self.notificationName, object: nil)
                    }
                    
                }
            }

        }
    }

        func updateMemories(){
            
            let memories = helper.readIDforRemove()
            
            for each in memories {
                 let recordID = CKRecordID(recordName: each)
                database.fetch(withRecordID: recordID, completionHandler: { (record, error) in
                    if ((error) != nil){
                        print(error?.localizedDescription)
                    } else{
                        
                        record?["isRemoved"] = 1 as CKRecordValue
                        
                        self.database.save(record!, completionHandler: { (record, error) in
                            if((error) != nil){
                                print(error?.localizedDescription)
                            }else{
                                self.helper.markMemoryAsUpload(withUUID: record?.object(forKey: "uuid") as! String, ckRecordID: (record?.recordID.recordName)!)
                                DispatchQueue.main.async() {
                                    //NotificationCenter.default.post(name: self.notificationName, object: nil)
                                }
                            }
                        })
                        
                        
                    }
                })
                
            }
            
        }
        
        func downloadMemories(){
            let predicate:NSPredicate = NSPredicate(value: true)
            let query:CKQuery = CKQuery(recordType: "OurMemory", predicate: predicate)
            
            database.perform(query, inZoneWith: nil) { (records, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    
                }else{
                    for each in records! {
                        let uuid =  each.object(forKey: "uuid") as! String
                        let time =  each.object(forKey: "timeStamp") as! Int
                        let remark =  each.object(forKey: "remark") as! String
                        let isRemoved = each.object(forKey: "isRemoved") as! Int
                        let recordID = each.recordID.recordName
                        
                        let memory = KeyMemory()
                        memory.remark = remark
                        memory.isRemoved =  isRemoved
                        memory.time = TimeInterval(time)
                        memory.uuid = uuid
                        
                        self.helper.insertMemory(memory)
                        self.helper.markMemoryAsUpload(withUUID: uuid, ckRecordID: recordID)
                    
                    }
                    DispatchQueue.main.async() {
                        NotificationCenter.default.post(name: self.notificationName, object: nil)
                    }
                   
                }
            }

        }
    
     
        
    

}
