//
//  ContactProfile.swift
//  
//
//  Created by Tommy Qiu on 8/11/17.
//
//

import FirebaseDatabase
import FirebaseAuth
import UIKit
import SpriteKit


class ContactProfileTableVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var myTableView: UITableView!{
        didSet {
        }
    }
    
    var thisContact = Contact()
    var socialMedias = [String]()
    var URLS = [String]()
    var accounts = [String:String]() { didSet {
        myTableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        
        print(thisContact.uid ?? "No ID")
        let rootRef = Database.database().reference().child("users")
        rootRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let allUsers = snapshot.value as? [String:Any]
            for user in (allUsers?.keys)!{
                if user == ((self.thisContact.uid)!){
                    let accounts = snapshot.childSnapshot(forPath: user).childSnapshot(forPath: "Accounts").value as! [String:String]
                    
                    for (media,URL) in accounts{
                        self.socialMedias.append(media)
                        self.URLS.append(accounts[media]!)
                        self.accounts[media] = URL
                    }
                    break
                }
            }
        })
        

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let viewController = UIViewController()
        let webView = UIWebView()
        if (URLS[indexPath.row]).hasPrefix("https://"){
            webView.loadRequest(URLRequest(url: URL(string:URLS[indexPath.row])!))
            }
        else{
            webView.loadRequest(URLRequest(url: URL(string:"https://" +  URLS[indexPath.row])!))
        }

        print(URLS[indexPath.row])
        
        viewController.view.addSubview(webView)
        webView.anchor(top: viewController.view.topAnchor, left: viewController.view.leftAnchor, bottom: viewController.view.bottomAnchor, right: viewController.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 1, height: 1)
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 58))
        viewController.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(backButton))
        navItem.leftBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        present(viewController, animated: true, completion: nil)
    }
    
    func backButton(){
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountsCell", for: indexPath)
        cell.textLabel?.text = socialMedias[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.socialMedias.count
    }
}
