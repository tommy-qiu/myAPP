//
//  UserService.swift
//  myApp
//
//  Created by Tommy Qiu on 8/15/17.
//  Copyright © 2017 Tommy Co. All rights reserved.
//

import Foundation


import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
}
}
