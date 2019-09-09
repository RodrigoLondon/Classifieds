//
//  AdController.swift
//  Classifieds
//
//  Created by Lewis Jones on 10/03/2019.
//  Copyright © 2019 Rodrigo. All rights reserved.
//

import Foundation
import CloudKit

class AdController {
 
    static let shared = AdController()
    
    static let adsWereUpdatedNotification = Notification.Name("adsWereUpdatedTo")
    
    var puppyAds: [Ad] = [] {
        didSet{
            NotificationCenter.default.post(name: AdController.adsWereUpdatedNotification, object: nil)
        }
    }
    var kittenAds: [Ad] = [] {
        didSet{
            NotificationCenter.default.post(name: AdController.adsWereUpdatedNotification, object: nil)
        }
    }
    
    let database = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    
    func saveRecordToCloudKit(title: String, price: Int, category: String) {
        
        let ad = Ad(title: title, price: price, category: category)
        
        let record = CKRecord(ad: ad)
        
        database.save(record) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if category == "Puppies" {
                self.puppyAds.append(ad)
            } else {
                self.kittenAds.append(ad)
            }
        }
        
    }
    
    func fetchRecords(category: String) {
        
        let predicate = NSPredicate(format: "category == %@", category)
        let query = CKQuery(recordType: "Ad", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let records = records else { return }
            
            let ads = records.compactMap({ Ad(ckRecord: $0) })
            
            if category == "Puppies" {
                self.puppyAds = ads
            } else {
                self.kittenAds = ads
            }
            
        }
        
    }
    
    func subscribeToPuppyAds() {
        
        let predicate = NSPredicate(format: "category == %@", "Puppies")
        let subscription = CKQuerySubscription(recordType: "Ad", predicate: predicate, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "Yayy!"
        notificationInfo.alertBody = "There is anew puppie ad."
        notificationInfo.soundName = "default"
        
        subscription.notificationInfo = notificationInfo
        
        database.save(subscription) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("Success")
        }
    }
}
