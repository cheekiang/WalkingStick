//
//  userconfig.swift
//  WalkingStickSG
//
//  Created by Chee Kiang Tan on 3/9/16.
//  Copyright © 2016 Govtech. All rights reserved.
//

//import Foundation
import UIKit

class usersettings: NSObject, NSCoding {
    // MARK: Properties
    
    var stickid: String
    var stickusername: String
    var stickuserphone: String
    var caregiverphone: String
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("settings")
    
    // MARK: Types
    
    struct PropertyKey {
        static let stickidKey = "id"
        static let nameKey = "name"
        static let stickuserphoneKey = "userphone"
        static let caregiverphoneKey = "carephone"
    }
    
    // MARK: Initialization
    
    init?(id: String, name: String, stickuser: String, caregiver: String) {
        // Initialize stored properties.
        self.stickid = id
        self.stickusername = name
        self.stickuserphone = stickuser
        self.caregiverphone = caregiver
        
        super.init()
        
        // Initialization should fail if there is no name or or no stickuserphone or no caregiverphone
        if stickid.isEmpty || stickusername.isEmpty || stickuserphone.isEmpty || caregiverphone.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(stickid, forKey: PropertyKey.stickidKey)
        aCoder.encodeObject(stickusername, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(stickuserphone, forKey: PropertyKey.stickuserphoneKey)
        aCoder.encodeObject(caregiverphone, forKey: PropertyKey.caregiverphoneKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let stickid = aDecoder.decodeObjectForKey(PropertyKey.stickidKey) as! String
        let stickusername = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let stickuserphone = aDecoder.decodeObjectForKey(PropertyKey.stickuserphoneKey) as! String
        let caregiverphone = aDecoder.decodeObjectForKey(PropertyKey.caregiverphoneKey) as! String
        
        // Must call designated initializer.
        self.init(id: stickid, name: stickusername, stickuser: stickuserphone, caregiver: caregiverphone)
    }
    
}



