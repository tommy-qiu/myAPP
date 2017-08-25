////
////  User.swift
////  myApp
////
////  Created by Tommy Qiu on 7/28/17.
////  Copyright © 2017 Tommy Co. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User : NSObject {
    // MARK: - Singleton
    
    // 1
    private static var _current: User?
    
    // 2
    static var current: User {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // 5
    
    // 1
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // 2
        if writeToUserDefaults {
            // 3
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // 4
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
    
    // MARK: - Properties
    
    let uid: String
    var socialMediaAccounts = [String: String]()
    
    // MARK: - Init
    
    init(uid: String) {
        self.uid = uid
        
        
        super.init()
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let socialMediaAccounts = dict["Accounts"] as? NSDictionary
            else { return nil }
        
        self.uid = snapshot.key
        self.socialMediaAccounts = socialMediaAccounts as! [String : String]
        
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
        let socialMediaAccounts = aDecoder.decodeObject(forKey: Constants.UserDefaults.accounts) as? NSDictionary
            else { return nil }
        
        self.uid = uid
        self.socialMediaAccounts = socialMediaAccounts as! [String : String]
        
        super.init()
    }
    
}
extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(socialMediaAccounts, forKey: Constants.UserDefaults.accounts)
    }
}
