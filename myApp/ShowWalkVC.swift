//
//  ShowWalkVC.swift
//  myApp
//
//  Created by Tommy Qiu on 7/31/17.
//  Copyright © 2017 Tommy Co. All rights reserved.
//
import UIKit
import BWWalkthrough


class CustomPageViewController: UIViewController, BWWalkthroughPage{
    override var prefersStatusBarHidden : Bool {
        return true
    }
    @IBOutlet var imageView:UIImageView?
    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var textLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: BWWalkThroughPage protocol
    
    func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
        var tr = CATransform3DIdentity
        tr.m34 = -1/500.0
        
        titleLabel?.layer.transform = CATransform3DRotate(tr, CGFloat(Double.pi) * (1.0 - offset), 1, 1, 1)
        textLabel?.layer.transform = CATransform3DRotate(tr, CGFloat(Double.pi) * (1.0 - offset), 1, 1, 1)
        
        var tmpOffset = offset
        if(tmpOffset > 1.0){
            tmpOffset = 1.0 + (1.0 - tmpOffset)
        }
        imageView?.layer.transform = CATransform3DTranslate(tr, 0 , (1.0 - tmpOffset) * 200, 0)
    }
    
}


class BWVC: UIViewController, BWWalkthroughViewControllerDelegate {
  
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "walkthroughPresented") {
            
            showWalkthrough()
            
            userDefaults.set(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewController(withIdentifier: "walk0")
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        walkthrough.add(viewController:page_zero)
        
        self.present(walkthrough, animated: true, completion: nil)
    }
    
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

