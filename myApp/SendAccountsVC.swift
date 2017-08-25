//
//  SendAccountsVC.swift
//  myApp
//
//  Created by Tommy Qiu on 8/9/17.
//  Copyright © 2017 Tommy Co. All rights reserved.


import UIKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth
import Foundation
import NVActivityIndicatorView


struct UIViewWithID{
    var view =  UIView()
    var ID = String()
    var Name = String()
//    var imageView = UIImageView()
}







class SendAccountsVC: UIViewController, CLLocationManagerDelegate {
    
    //CLLocation items
    var manager = CLLocationManager()
    var panGesture = UIPanGestureRecognizer()
    var verticalAccuracy = CLLocationAccuracy()
    var horizontalAccuracy = CLLocationAccuracy()
    var headingAccuracy = CLLocationAccuracy()
        
    //Flags
    var testFlag = false
    var updateLocationsFlag = false
    var updateHeadingFlag = false
    var updateDatabaseFlag = false
    var updateCardsFlag = false
    var loadedCardsFlag = false {didSet{
        self.view.addSubview(self.myCard)
        self.myCard.anchor(top: self.view.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 20, paddingLeft: 100 , paddingBottom: 40, paddingRight: 100, width: 150, height: 25)
        
        //        print(self.viewArray.count,"viewArray count")
        for view in self.viewArray{
            if viewArrayCounter % 3 == 0 && viewArrayCounter != 0{
                self.currentCoord.y = self.currentCoord.y + 40
                self.currentCoord.x = self.currentCoord.x - 300
            }
            view.view.center = self.currentCoord
            self.currentCoord.x = self.currentCoord.x + 100
            self.view.addSubview(view.view)
            self.viewArrayCounter += 1
        }
        
        UIView.animate(withDuration: 0.75, animations: {() -> Void in
            self.myCard.frame.size = CGSize(width: 150, height: 40)
            for view in self.viewArray{
                view.view.frame.size = CGSize(width: 60, height: 12)
            }
        })
        }
    }
    
    //Counters
    var viewArrayCounter = 0
    var requestCounter = 0

    
    //Business Cards
    var myCard = UIView(frame: CGRect(x: -100, y: 100, width: 0, height: 0))
    var viewArray = [UIViewWithID]()
    

    //User Arrays
    var nameArrays = [String]() //
    var otherUsers = [String]() //
    

    //For or from Firebase
    var dic : NSMutableDictionary  = [:]
    var heading = Double()
    
    //Animation
    var animateView : NVActivityIndicatorView?
    
    
    //Coordinates
    var currentCoord = CGPoint(x: 10, y: 70)
    var outsideCoord = CGPoint(x: -100 , y : -100)

    
    //Methods
    func setUpNewOtherCard(userID: String, name: String) {
        let containerView = UIView()
        containerView.center = outsideCoord
        containerView.frame.size.width = 0
        containerView.frame.size.height = 0
//        let imageName = "stock_guy.jpg"
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
//        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
//        containerView.addSubview(imageView)
//        let newViewWithID = UIViewWithID(view: containerView, ID: userID, Name: name,imageView: imageView)
        print(userID,"ID")
        let newViewWithID = UIViewWithID(view: containerView, ID: userID, Name: name)
        
        viewArray.append(newViewWithID)
        containerView.backgroundColor = UIColor.blue
//        self.view.addSubview(containerView)
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.updateLocationsFlag == false{
            self.updateLocationsFlag = true
            print("location")
            
            let location = locations[0]
            
    //        print(locations)
    //        print("Horizontal Accuracy", location.horizontalAccuracy)
            self.horizontalAccuracy = location.horizontalAccuracy
            self.verticalAccuracy = location.verticalAccuracy
            
            dic["altitude"] = location.altitude
    //        print(location.altitude)

            dic["latitude"] = location.coordinate.latitude
            dic["longitude"] = location.coordinate.longitude
    //        print(location.coordinate.latitude)
    //        print(location.coordinate.longitude)
            
    //        print("Location Here")
            if self.updateLocationsFlag && self.updateHeadingFlag && (!self.updateDatabaseFlag){
                self.updateDatabaseFlag = true
                self.updateDatabase()
                
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        if self.updateHeadingFlag == false{
            self.updateHeadingFlag = true
            print("heading")
                self.heading = newHeading.trueHeading
    //        print("True Heading: ",newHeading.trueHeading)
    //        print("Accuracy Heading: ",newHeading.headingAccuracy)
            self.headingAccuracy = newHeading.headingAccuracy
            
    //        print("Heading Here")
            if self.updateLocationsFlag && self.updateHeadingFlag && (!self.updateDatabaseFlag){
                self.updateDatabaseFlag = true
                self.updateDatabase()
            }

        }
    }
    
    

    func updateDatabase(){
        if self.updateDatabaseFlag{
            if let user = Auth.auth().currentUser {
    //            print("YES")
                let rootRef = Database.database().reference()
                rootRef.child("requests").observeSingleEvent(of: .value, with: {(snapshot) in
                    if snapshot.exists() == false {
                        
    //                    rootRef.updateChildValues(["requests" : self.dic as NSDictionary])
                        let currentUser = [user.uid: self.heading]
                        self.dic["currentUsers"] = currentUser as NSDictionary
                        rootRef.updateChildValues(["requests" : self.dic as NSDictionary])
    //                    rootRef.child("requests").setValue(currentUser)
                    }
                    if snapshot.exists() == true{
                        if snapshot.childSnapshot(forPath: "currentUsers").hasChild(user.uid) == true {
                            rootRef.child("requests").child("currentUsers").updateChildValues([user.uid : self.heading])
                            print("I am here")
    //                        self.updateCardsFlag = true
                        }
                        else{
                            print("I am not here")
                            snapshot.childSnapshot(forPath: "currentUsers").ref.updateChildValues([user.uid:self.heading])
                            
    //                        self.updateCardsFlag = true
                        }
                    }
                    guard let dict = snapshot.value as? [String: Any]
                        else {return}
                    
    //                self.checkUserestoAddtoMainView()
                    
                    let myAltitude = self.dic["altitude"] as! CLLocationDistance
                    let theirAltitude = dict["altitude"] as! CLLocationDistance
                    let myLongtitude = self.dic["longitude"] as! CLLocationDistance
                    let theirLongtitude = dict["longitude"] as! CLLocationDistance
                    let myLatitude = self.dic["latitude"] as! CLLocationDistance
                    let theirLatitude = dict["latitude"] as! CLLocationDistance
                    
    //                print(self.verticalAccuracy)
    //                print(myAltitude)
    //                print(theirAltitude)
                    let myAltituderange = myAltitude > theirAltitude - (self.verticalAccuracy) && myAltitude < theirAltitude + (self.verticalAccuracy)
                    let myLongtitudeRange = myLongtitude > theirLongtitude - (self.horizontalAccuracy) && myLongtitude < theirLongtitude + (self.horizontalAccuracy)
                    let myLatitudeRange  = myLatitude > theirLatitude - (self.horizontalAccuracy) && myLatitude < theirLatitude + (self.horizontalAccuracy)
                    if myAltituderange && myLongtitudeRange && myLatitudeRange && !(self.testFlag){
                        self.testFlag = true
                        DispatchQueue.main.asyncAfter(deadline: .now() +  0.60) { // in half a second...
                            self.checkUserstoAddtoMainView()
                        }
                        
                    }
                })
                }
            }
    }
    
    
    func emptyAlert(){
        let emptyAlert : UIAlertController = UIAlertController(title: "Empty", message: "Nobody is around or you are not facing them (Try changing the direction of the phone", preferredStyle: .alert)
        emptyAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        let currVC = self
        emptyAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {(self) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            var viewcontrollers = currVC.navigationController?.viewControllers
            viewcontrollers?.removeLast()
            let vc = storyboard.instantiateViewController(withIdentifier: "sendAccountsVC")
            viewcontrollers?.append(vc)
            currVC.navigationController?.setViewControllers(viewcontrollers!, animated: false)

        }))
        self.present(emptyAlert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Start animation
        self.animateView = NVActivityIndicatorView(frame: self.view.frame, type: .ballScale, color: UIColor.blue, padding: 10)
        self.view.addSubview(self.animateView!)
        self.animateView!.startAnimating()
        
        //        print(self.navigationItem.title,"TITTTLE")
        //        print(self.navigationItem.backBarButtonItem?.description,"THINGNG")
        //
        self.updateLocationsFlag = false
        self.updateHeadingFlag = false
        self.updateDatabaseFlag = false
        
        

    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        //Set up CoreLocations
        
        
//        weak var delegaeMan = manager.delegate
        manager.delegate = self
        print(manager.delegate ?? "No delegate")
//        delegaeMan = self
//        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.headingFilter = 15
        manager.distanceFilter = 10
        manager.startUpdatingHeading()
        manager.startUpdatingLocation()
        
        
        //Set up myCard and being able to drag it
        myCard.backgroundColor = UIColor.black
        panGesture = UIPanGestureRecognizer.init(target: self,action: #selector(viewDidDrag))
        myCard.addGestureRecognizer(panGesture)
        }

    
    
    
    func viewDidDrag(){
        let newPoint = panGesture.location(in: self.view)
        let newFrame = CGRect(x: newPoint.x - (myCard.frame.size.width/2), y: newPoint.y -  (myCard.frame.size.height/2) ,width: myCard.frame.size.width, height: myCard.frame.size.height)
        myCard.frame = newFrame
        
        
        if panGesture.state == .ended{
            var contactCheckedFlag = false
            for view in viewArray{
                if self.myCard.frame.intersects(view.view.frame) {
                    print("HIT")
                    
                    let newUser = view.Name
                    for singleContact in CoreDataHelper.retrieveNotes(){
                        if let name = singleContact.contactName{
                            if name == newUser{
                                showAlert(withTitle: "Contact has been already added", message: "Contact is already part of contact")
                                contactCheckedFlag = true
                            }
                        }
                    }
                    
                    view.view.removeFromSuperview()
//                    view.view.frame = CGRect(origin: outsideCoord, size: CGSize(width: 0, height: 0))
                    
//                    self.viewsRemoved += 1
                    if contactCheckedFlag == false{
                        
                        let AddedAlert : UIAlertController = UIAlertController(title: "Added Contact", message: view.Name, preferredStyle: .alert)
                        AddedAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        present(AddedAlert, animated: true, completion: nil)
                        let newContact = CoreDataHelper.newContact()
                        newContact.contactName = view.Name
                        newContact.uid = view.ID
                        
                        CoreDataHelper.saveContact()
                        
                    }

                }
            }
            
        }
        
        
            let translation = panGesture.translation(in: self.view)
//            let self.navigationController.UINavigationBar.newFrame.
            let navBarframe = self.navigationController?.navigationBar
//            print(frame?.bounds.width ?? "No Bar")
//            print(frame?.bounds.height ?? "No Bar")
        
            let newX = panGesture.view!.center.x + translation.x
            let newY = panGesture.view!.center.y + translation.y
            let senderWidth = panGesture.view!.bounds.width / 2
            let senderHeight = panGesture.view!.bounds.height / 2
        
        
        
            let openScreen = CGRect(x: 0, y: (navBarframe?.bounds.height)!, width: self.view.bounds.maxX, height: self.view.bounds.maxY -  (navBarframe?.bounds.height)!)
        
            openScreen.offsetBy(dx: 0, dy: (navBarframe?.bounds.height)!)
//            print(openScreen.origin)
        
            if newX <= senderWidth
            {
                panGesture.view!.center = CGPoint(x: senderWidth, y: panGesture.view!.center.y + translation.y)
            }
            else if newX >= openScreen.maxX - senderWidth
            {
                panGesture.view!.center = CGPoint(x: openScreen.maxX - senderWidth, y: panGesture.view!.center.y + translation.y)
            }
            if (newY - openScreen.origin.y - 10  <= senderHeight)
            {
                panGesture.view!.center = CGPoint(x: panGesture.view!.center.x + translation.x, y: senderHeight)
            }
            else if newY >= (openScreen.maxY - senderHeight)
            {
                panGesture.view!.center = CGPoint(x: panGesture.view!.center.x + translation.x, y: openScreen.maxY - senderHeight)
            }
            else
            {
                panGesture.view!.center = CGPoint(x: panGesture.view!.center.x + translation.x, y: panGesture.view!.center.y + translation.y)
            }
        
        let point = CGPoint(x: 0 ,y: 0)
        panGesture.setTranslation(point, in: self.view)
//        panGesture.setTranslation(CGPoint(0,0), in: self.view)
        
        
 
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func checkUserstoAddtoMainView(){
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        if let user = Auth.auth().currentUser{
            let rootRef = Database.database().reference()

            rootRef.observeSingleEvent(of: .value, with: {(snapshot) in
                let usersNearSnapshot = snapshot.childSnapshot(forPath: "requests").childSnapshot(forPath: "currentUsers")
                
                let userHeadingDic = usersNearSnapshot.children.allObjects as! [DataSnapshot]
                var UIDs = [String]() 
                
                let leftBound = self.heading   - self.headingAccuracy
                let rightBound = self.heading  + self.headingAccuracy
                
                print(leftBound,"Left")
                
                
                print(self.heading)
                
                print(rightBound,"Right")
                for userID in userHeadingDic {
                    let currUser = userID.key
                    print(userID.value!, "thin.value")
                    if ((userID.value as! Double) - 180) > leftBound && ((userID.value as! Double) - 180) < rightBound { //This is to check that the users are facing eachother
                        print(currUser,"HERE")
                        if user.uid != currUser{
                            UIDs.append(currUser)
                        }
                    }
                    
                }
                
                self.otherUsers = UIDs
                
                for currUser in UIDs{
                    if currUser != user.uid {
                    guard let thisUser = snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: currUser).childSnapshot(forPath: "Name").value
                                                else {return}
                        let userName = thisUser as! String
                        self.nameArrays.append(userName)
                    }
                }
//                print(self.nameArrays,"nameArray")
                
                self.animateView?.stopAnimating()
//                print(self.otherUsers.count, "Count")
                if self.otherUsers.count == 0{
                    self.emptyAlert()
                    self.loadedCardsFlag = true
                }
                else{
                for index in 0 ..< self.otherUsers.count {
//                    print(self.otherUsers[index])
//                    print(self.nameArrays[index])
                    self.setUpNewOtherCard(userID: self.otherUsers[index], name: self.nameArrays[index])
                    if (index == self.otherUsers.count - 1){
                        self.loadedCardsFlag = true
                    }
                }
            }
        })
    }
}
    override func viewWillDisappear(_ animated: Bool) {
        manager.delegate = nil
        if let user = Auth.auth().currentUser {
            // 2
            let rootRef = Database.database().reference()
            let userRef = rootRef.child("requests").child("currentUsers")
            userRef.child(user.uid).removeValue()
            userRef.observe(.value, with: {(snapshot) in
                if Int(snapshot.childrenCount) == 0{
                    rootRef.child("requests").removeValue()
                }
            })
        }
        if self.animateView!.isAnimating{
            self.animateView!.stopAnimating()
        }
    }
}

extension SendAccountsVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//         (viewController as? MainViewController)?.users = addedNames
        
    }
}
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}




