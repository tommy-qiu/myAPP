//
//  Main.swift
//  myApp
//
//  Created by Tommy Qiu on 7/28/17.
//  Copyright © 2017 Tommy Co. All rights reserved.
//


import UIKit
import CoreData
import FirebaseDatabase
import FirebaseAuth

class Contact : NSManagedObject{
    @NSManaged var contactName : String?
    @NSManaged var uid : String?
    @NSManaged var contactType : String?
}




class MainViewController : UIViewController,UITableViewDelegate,UITableViewDataSource{
    var contacts = [Contact]()
    
    var selectedContact = Contact()
    
    override func viewDidLoad() {
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            let rootRef = Database.database().reference()
            let userRef = rootRef.child("users").child(user.uid)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let userDict = snapshot.value as? [String : Any] {
                    print(userDict["Accounts"] ?? "None")
                }
            })
        } else{
            print("nope")
        }
    }
    
    
    
    @IBOutlet weak var myTableView: UITableView!
    //Table View Functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedContact = self.contacts[(indexPath.row)]
        
        NSLog("You selected cell number: \(indexPath.row)!")
        let viewController = self.navigationController?.topViewController as? ContactProfileTableVC
        viewController?.thisContact = self.selectedContact
        NSLog((viewController?.thisContact.uid)!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell",for :indexPath)
        cell.textLabel?.text = contacts[indexPath.row].contactName
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
        
    }

    
    
    @IBAction func resetButton(_ sender: Any) {
                // Create Fetch Request
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        
                // Create Batch Delete Request
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
                do {
                    try CoreDataHelper.managedContext.execute(batchDeleteRequest)
        
                } catch {
                    // Error Handling
                }
        self.contacts = [Contact]()
        self.myTableView.reloadData()
        
    }
    
    
    //Unwind Segue
    @IBAction func unWindMainVC(segue:UIStoryboardSegue){
        
    }
    
    
  
  
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(true)
        let savedContacts = CoreDataHelper.retrieveNotes()
        contacts = savedContacts
        
        self.myTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print(contacts.count)
        self.myTableView.reloadData()

    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
