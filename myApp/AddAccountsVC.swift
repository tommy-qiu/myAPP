//
//  AccountsViewController.swift
//  myApp
//
//  Created by Tommy Qiu on 7/26/17.
//  Copyright © 2017 Tommy Co. All rights reserved.

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

struct Account{
    var url:String
    var socialMedia: String
}
//var currentUser: User? { get }

func verifyUrl(urlString: String?) -> Bool {
    guard let urlString = urlString,
        let url = NSURL(string: urlString) else {
            return false
    }
    
    return UIApplication.shared.canOpenURL(url as URL)
}



class AddAccountsViewController : UITableViewController , UITextFieldDelegate{
 
    @IBOutlet weak var buttonView: UIView!
    
    var dic : Dictionary<String,String> = [:]
    var classAccounts = [Account]()
    var accountsSocialMedia = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBAction func unwindYes(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func AddAccount(_ sender: Any) {
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        buttonView.layer.cornerRadius = 10;
        buttonView.layer.masksToBounds = true;
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsSocialMedia.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for :indexPath) as! AddCell
        cell.labelTitle?.text = accountsSocialMedia[indexPath.row]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "AccountSelectionSegue"{
            return
        }
        else if segue.identifier == "ContinueToRegSegue" || segue.identifier == "returnToProfile" {
            
            let cells = self.tableView.visibleCells as! Array<AddCell>
            if cells.count == 0{
               

                let noSocialAlert : UIAlertController = UIAlertController(title: "No accounts added", message: "Please add a few accounts to use this app effectively", preferredStyle: .alert)
                noSocialAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                present(noSocialAlert, animated: true, completion: nil)
                
            }
            
            for cell in cells {
                let socialMedia = cell.labelTitle.text
                
                guard let urlText = cell.textField.text, urlText != ""else{
                    if socialMedia! == "Phonenumber" && cell.textField.text?.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
                        let urlAlert : UIAlertController = UIAlertController(title: "Phone Number", message: "Empty or incorrect Phone", preferredStyle: .alert)
                        urlAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        present(urlAlert, animated: true, completion: nil)
                        return
                    }
                    else if socialMedia! == "Email" && !((cell.textField.text?.hasSuffix(".com"))!){
                        if socialMedia! == "Phonenumber" && cell.textField.text?.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
                            let urlAlert : UIAlertController = UIAlertController(title: "Email", message: "Empty or incorrect Email", preferredStyle: .alert)
                            urlAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            present(urlAlert, animated: true, completion: nil)
                            return
                        }
                    }
                    else if verifyUrl(urlString: cell.textField.text) == false && cell.textField.text?.contains(".com") == false{
                            let urlAlert : UIAlertController = UIAlertController(title: "Account", message: "Empty or incorrect account or incorrect URL", preferredStyle: .alert)
                            urlAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            present(urlAlert, animated: true, completion: nil)
                            return
                            }
                    return
                    }
                
                
                
                self.classAccounts = [Account]()
                let tempAcc = Account(url: cell.textField.text!, socialMedia: cell.labelTitle.text!)
                print(cell.textField.text!)
                self.classAccounts.append(tempAcc)
                    }
            if segue.identifier == "ContinueToRegSegue"{
                let tempFinishReg = segue.destination as! FinishRegVC
                self.dic = [:]
                
                for account in self.classAccounts{
                    self.dic[account.socialMedia] = account.url
                }
                tempFinishReg.dic = self.dic
                tempFinishReg.passedAccountsArray = self.classAccounts
            }
            else if segue.identifier == "toAccountsMain"{
                print("fdsFd")
            }
        }
    }
    
    

            
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}




