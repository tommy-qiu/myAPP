//
//  AccountSelection.swift
//  myApp
//
//  Created by Tommy Qiu on 7/27/17.
//  Copyright © 2017 Tommy Co. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

var accounts = ["Facebook","LinkedIn","GitHub","Snapchat","SoundCloud","Wechat","Medium","Devpost","Instagram","Twitter","Email","Phonenumber","WhatsApp","Line"]

var URLs = [String]()

var count = 0
class AccountSelection :UITableViewController, UISearchBarDelegate{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching = false
    var temp = String()

    var filteredAccounts = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filteredAccounts.count
        }
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell",for :indexPath) as! selectionCell
        if isSearching{
            cell.labelTitle?.text = filteredAccounts[indexPath.row]
            
//            cell.textField.text = "DSADASA"
            return cell
        }
        cell.labelTitle?.text = accounts[indexPath.row]
       
        
//        cell.textField.text = "DSADASA"
//        cell.textField.
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else{
            isSearching = true
            filteredAccounts = accounts.filter({$0.contains(searchBar.text!)})
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            let addAccountVC = segue.destination as! AddAccountsViewController
            let indexPath = tableView.indexPathForSelectedRow
            let temp = Account(url: "\(accounts[(indexPath?.row)!]).com", socialMedia: accounts[(indexPath?.row)!])
        if addAccountVC.dic[accounts[(indexPath?.row)!]] == nil{
            addAccountVC.dic[accounts[(indexPath?.row)!]] = "\(accounts[(indexPath?.row)!]).com"
        }
//            temp.url = "\(accounts[(indexPath?.row)!]).com"
//            temp.socialMedia = accounts[(indexPath?.row)!]
            addAccountVC.classAccounts.append(temp)
            addAccountVC.accountsSocialMedia.append(accounts[(indexPath?.row)!])
            let lastAccountInArray = addAccountVC.accountsSocialMedia.last!
            if lastAccountInArray == "Email"{
                return
            }
            let indexOf = accounts.index(of: lastAccountInArray)
            accounts.remove(at: indexOf!)
        
    }


}
