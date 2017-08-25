//
//  ViewController.swift
//  myApp
//
//  Created by Tommy Qiu on 7/26/17.
//  Copyright © 2017 Tommy Co. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI

import FirebaseDatabase
typealias FIRUser = FirebaseAuth.User
class OpenScreenVC: UIViewController {
    let user: FIRUser? = Auth.auth().currentUser

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func viewDidAppear(_ animated: Bool) {
        if self.isLoggedIn(){
            
            let manVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNav") as! NavVC
            present(manVC, animated: true, completion: nil)
            
    }
    }
    
    func isLoggedIn() -> Bool{
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

