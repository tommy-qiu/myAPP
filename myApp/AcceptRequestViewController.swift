//
//  WebsiteViewController.swift
//  myApp
//
//  Created by Tommy Qiu on 7/28/17.
//  Copyright © 2017 Tommy Co. All rights reserved.
//

import Foundation
import UIKit
class WebsiteViewController : UIViewController
{

    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var Next: UIButton!
    var count = 0
    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let url = URL (string: URLS[count])
//        let requestObj = URLRequest(url: url!)
//        myWebView.loadRequest(requestObj)
    }
    
}
