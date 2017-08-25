//
//  SignUpController.swift
//  myApp
//
//  Created by Tommy Qiu on 7/31/17.
//  Copyright © 2017 Tommy Co. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import BWWalkthrough

class myTextField : UITextField{
    override func clearButtonRect(forBounds: CGRect) -> CGRect{
        var original = super.clearButtonRect(forBounds: forBounds)
        original.origin.x = original.origin.x - 15
        return original
    }
}


class SignUpVC : UIViewController , UITextFieldDelegate {

    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    
    
    let inputContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
        
    }()
    
    
    @IBAction func unwindToSignIn(segue:UIStoryboardSegue){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                //instantiating the input viewer
            view.addSubview(inputContainerView)
            view.addSubview(RegButton)
            view.addSubview(loginButton)
            
            setupInputContainerView()
            setupRegButton()
            setupLogInButton()
            self.emailTextField.delegate = self
            self.PassTextField.delegate = self
        }

    let emailTextField: UITextField = {
        
        let tf = myTextField()
        
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        return tf
        
    }()
    
    let emailSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 103, g: 167, b: 231)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let PassTextField: UITextField = {
        
        let tf = myTextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.clearButtonMode = .whileEditing
        return tf
        
    }()
    
    lazy var RegButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        button.addTarget(self, action: #selector(handleRegButton), for: .touchUpInside)
        return button
    }()
    
    func handleRegButton(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let accountSelectorView :AddAccountsViewController = storyboard.instantiateViewController(withIdentifier: "accountSelectionView") as! AddAccountsViewController
        self.present(accountSelectorView, animated: true, completion: nil)
        
    }
    
    
    

    lazy var loginButton: UIButton = {
        
        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor(r: 58, g: 21, b: 128)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        return button
    }()
    
    func handleLoginButton(){
        guard let emailText = emailTextField.text, emailText != "" else{
            let emailAlert : UIAlertController = UIAlertController(title: "Email", message: "Empty or incorrect email", preferredStyle: .alert)
            emailAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(emailAlert, animated: true, completion: nil)
            return
        }
        guard let passText = PassTextField.text, passText != "" else{
            let passAlert : UIAlertController = UIAlertController(title: "Password", message: "Empty or incorrect password", preferredStyle: .alert)
            passAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(passAlert, animated: true, completion: nil)
            return
        }


        Auth.auth().signIn(withEmail: emailText, password: passText) { (user, error) in
            if let FirebaseErrror = error{
                let FireAlert =  UIAlertController(title: "Log In", message: FirebaseErrror.localizedDescription, preferredStyle: .alert)
                FireAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(FireAlert, animated: true, completion: nil)
                return
            
            }
            print("success")
//            self.rememberLogIn()
            
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController :UINavigationController = storyboard.instantiateViewController(withIdentifier: "mainNav") as! UINavigationController
            
            
            self.present(mainViewController, animated: true, completion: nil)
        }
        
        
    }
    
//    let nameSeparator: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
//    let nameTextField: UITextField = {
//        
//        let tf = UITextField()
//        tf.placeholder = "Name"
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.clearButtonMode = .whileEditing
//        return tf
//        
//    }()

    

    func setupRegButton(){
        
        //Constraints :  need x,y, width and height
        RegButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RegButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 52).isActive = true
        
        //how wide
        RegButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        RegButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    func setupLogInButton(){
        
        //Constraints :  need x,y, width and height
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        
        //how wide
        loginButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    func setupInputContainerView() {
        
        //Constraints :  need x,y, width and height
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        
//        inputContainerView.addSubview(nameTextField)
//        inputContainerView.addSubview(nameSeparator)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparator)
        inputContainerView.addSubview(PassTextField)
        
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        //Constraints :  need x,y, width and height
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        //Constraints :  need x,y, width and height
        emailSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        //Constraints :  need x,y, width and height
        PassTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        PassTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        PassTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        PassTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
