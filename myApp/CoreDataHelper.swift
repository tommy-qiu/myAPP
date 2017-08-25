//
//  CoreDataHelper.swift
//  myApp
//
//  Created by Tommy Qiu on 8/21/17.
//  Copyright © 2017 Tommy Co. All rights reserved.
//

import CoreData
import UIKit

class CoreDataHelper {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    //static methods will go here
    
    static func newContact() -> Contact {
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: managedContext) as! Contact
        return contact
    }
    
    
    static func saveContact() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func delete(contact: Contact) {
        managedContext.delete(contact)
        saveContact()
    }
    
    static func retrieveNotes() -> [Contact] {
        let fetchRequest = NSFetchRequest<Contact>(entityName: "Contact")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
}
