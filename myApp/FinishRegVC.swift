//
//  FinishRegVC.swift
//  myApp
//
//  Created by Tommy Qiu on 8/8/17.
//  Copyright © 2017 Tommy Co. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FinishRegVC: UIViewController,UITextFieldDelegate {
    var passedAccountsArray = [Account]()
    var dic : Dictionary<String,String> = [:]

    @IBOutlet weak var finishRegButtonView: UIView!

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func finishRegButton(_ sender: Any) {
        guard let firstNameText = firstNameTextField.text, firstNameText != "" else{
            let firstNameAlert : UIAlertController = UIAlertController(title: "First Name", message: "No First Name", preferredStyle: .alert)
            firstNameAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(firstNameAlert, animated: true, completion: nil)
            return
        }
        
        guard let lastNameText = lastNameTextField.text, lastNameText != "" else{
            let lastNameAlert : UIAlertController = UIAlertController(title: "Last Name", message: "No Last Name", preferredStyle: .alert)
            lastNameAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(lastNameAlert, animated: true, completion: nil)
            return
        }
        
        guard let emailText = emailTextField.text, emailText != "" else{
            let emailAlert : UIAlertController = UIAlertController(title: "Email", message: "Empty Email", preferredStyle: .alert)
            emailAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(emailAlert, animated: true, completion: nil)
            return
        }
        
        guard let passText = passwordTextField.text, passText != "" else{
            let passAlert : UIAlertController = UIAlertController(title: "Password", message: "Empty password", preferredStyle: .alert)
            passAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(passAlert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: emailText, password: passText) { (user, error) in
            if let FirebaseErrror = error{
                let FireAlert =  UIAlertController(title: "Registration", message: FirebaseErrror.localizedDescription, preferredStyle: .alert)
                FireAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(FireAlert, animated: true, completion: nil)
                return
            }
            //            self.rememberLogIn()
            let userID = user!.uid
            let NNSDIC = NSDictionary(dictionary: self.dic)
            let data = ["Name" : "\(firstNameText) \(lastNameText)","Accounts": NNSDIC] as [String : Any]
//            print(self.dic.isEmpty)
//            print(self.passedAccountsArray.count)
            let ref = Database.database().reference().child("users").child(userID)
            ref.setValue(data) { (error, ref) in
                if let error = error {
                    print("user \(error.localizedDescription)")
                    return
                }
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let userResult = User(snapshot: snapshot)
                    guard let user = userResult else {
                        return
                    }
                    User.setCurrent(user, writeToUserDefaults: true)
                })
            }
//            print(NNSDIC.allKeys)
            //ref.child("users").child(userID).setValue(["Email":emailText, "Password": passText, "Name" : firstNameText + " " + lastNameText,"Accounts": NNSDIC])
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        finishRegButtonView.layer.cornerRadius = 10
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
