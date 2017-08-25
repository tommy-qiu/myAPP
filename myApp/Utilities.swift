//
//  Utilities.swift
//  myApp
//
//  Created by Tommy Qiu on 8/9/17.
//  Copyright © 2017 Tommy Co. All rights reserved.
//


import UIKit

extension UIViewController {
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
