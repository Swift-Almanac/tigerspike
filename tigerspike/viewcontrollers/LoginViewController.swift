//
//  LoginViewController.swift
//  tigerspike
//
//  Created by Mark Hoath on 1/12/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit


//
//  LoginViewController.swift
//  ridesharedj
//
//  Created by Mark Hoath on 1/10/18.
//  Copyright © 2018 Swift Almanac. All rights reserved.
//

import UIKit
import Firebase
import Vision

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let     nameTxt = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    let     usernameTxt = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    let     passwordTxt = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30 ))
    let     loginBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    let     forgotLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    let     loginAIV = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        nameTxt.placeholder = "Username"
        nameTxt.text = MyUser.shared.name
        nameTxt.textColor = .black
        nameTxt.textAlignment = .center
        nameTxt.autocapitalizationType = .words
        nameTxt.delegate = self
        nameTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        usernameTxt.placeholder = "Email Address"
        usernameTxt.text = MyUser.shared.username
        usernameTxt.textColor = .black
        usernameTxt.textAlignment = .center
        usernameTxt.autocapitalizationType = .none
        usernameTxt.delegate = self
        usernameTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        passwordTxt.placeholder = "Password"
        passwordTxt.textAlignment = .center
        passwordTxt.textColor = .black
        passwordTxt.autocapitalizationType = .none
        passwordTxt.isSecureTextEntry = true
        passwordTxt.delegate = self
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if MyUser.shared.username.isEmpty {
            loginBtn.setTitle("Create", for: .normal)
        } else {
            loginBtn.setTitle("Login", for: .normal)
        }
        
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.layer.cornerRadius = 8.0
        loginBtn.addTarget(self, action: #selector(loginEmail), for: .touchUpInside)
        
        forgotLbl.textAlignment = .center
        forgotLbl.textColor = .blue
        forgotLbl.attributedText = NSAttributedString(string: "reset password", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        forgotLbl.backgroundColor = .white
        forgotLbl.isUserInteractionEnabled = true
        
        loginAIV.isHidden = true
        loginAIV.hidesWhenStopped = true
        loginAIV.style = .whiteLarge
        loginAIV.color = .black
        
        view.addSubview(nameTxt)
        view.addSubview(usernameTxt)
        view.addSubview(passwordTxt)
        view.addSubview(loginBtn)
        view.addSubview(forgotLbl)
        view.addSubview(loginAIV)
        
        nameTxt.text = MyUser.shared.name
        usernameTxt.text = MyUser.shared.username
        
        nameTxt.isHidden = !MyUser.shared.name.isEmpty
        forgotLbl.isHidden = MyUser.shared.username.isEmpty
        
        setUpConstraints()
        testLoginBtn()
    }
    
    
    
    @objc func resetPassword() {
        
        passwordTxt.text = ""
        
        if usernameTxt.text != nil {
            
            let email = usernameTxt.text!
            if testEmailAddress(email: email) {
            
                MyFirebase.shared.resetPassword(username: email)
                
                let alert = UIAlertController(title: "Password Reset", message: "Check your email and change your password via the link provided", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Password Reset", message: "Please add a valid Email Address to the Username field!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)

            }
        } else {
            
            let alert = UIAlertController(title: "Password Reset", message: "Please add a valid Email Address to the Username field!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func testEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func testLoginBtn() {
        
        let email = usernameTxt.text!
        let password = passwordTxt.text!
        let name = nameTxt.text!
        
        if testEmailAddress(email: email) && password.count > 5 &&
            (name.count > 0 || nameTxt.isHidden) {
            loginBtn.isEnabled = true
            loginBtn.alpha = 1.0
            loginBtn.layer.backgroundColor = UIColor.green.cgColor
            loginBtn.setTitleColor(.black, for: .normal)
        } else {
            loginBtn.isEnabled = false
            loginBtn.alpha = 0.5
            loginBtn.layer.backgroundColor = UIColor.red.cgColor
            loginBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        testLoginBtn()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        // FIX Implement Tabbing between Text Fields
        if loginBtn.isEnabled {
            loginEmail()
        }
        return true
    }
    
    @objc func loginEmail() {
        let email = usernameTxt.text!
        let password = passwordTxt.text!
        let name = nameTxt.text!
        
        NetworkActivityIndicatorManager.shared.networkOperationStarted(closure: doNothing)
        loginAIV.isHidden = false
        loginAIV.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            NetworkActivityIndicatorManager.shared.networkOperationFinished()
            DispatchQueue.main.async {
                self.loginAIV.stopAnimating()
            }
            if error != nil {
                print (error?.localizedDescription ?? "")
                if (error?.localizedDescription.contains("password is invalid"))! {
                    DispatchQueue.main.async {
                        self.badPassword()
                        self.passwordTxt.text = ""
                    }
                } else {
                    self.createEmailUser(email: email, password: password)
                    MyUser.shared.name = name
                    MyUser.shared.username = email
                    MyUser.shared.saveDefaults()
                    MyFirebase.shared.saveUser()
                }
            } else {
                MyUser.shared.name = name
                MyUser.shared.username = email
                MyUser.shared.saveDefaults()
                MyFirebase.shared.saveUser()
            }
        })
    }
    
    func createEmailUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if (error != nil) {
                print(error?.localizedDescription ?? "")
            } else {
                MyUser.shared.username = email
                MyUser.shared.name = self.nameTxt.text!
                MyUser.shared.saveDefaults()
                MyFirebase.shared.saveUser()
            }
        })
    }
    
    func badPassword() {
        let alert = UIAlertController(title: "Bad Password", message: "Please try again", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpConstraints() {
        
        
        let fnCentreY = NSLayoutConstraint(item: nameTxt, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -40)
        let fnCentreX = NSLayoutConstraint(item: nameTxt, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let fnHeight = NSLayoutConstraint(item: nameTxt, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: 30)
        let fnWidth = NSLayoutConstraint(item: nameTxt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 200)
        
        nameTxt.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([fnCentreY, fnCentreX, fnHeight, fnWidth])
        
        let etCentreY = NSLayoutConstraint(item: usernameTxt, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 40)
        let etCentreX = NSLayoutConstraint(item: usernameTxt, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let etHeight = NSLayoutConstraint(item: usernameTxt, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: 30)
        let etWidth = NSLayoutConstraint(item: usernameTxt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 200)
        
        usernameTxt.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([etCentreY, etCentreX, etHeight, etWidth])
        
        let ptCentreY = NSLayoutConstraint(item: passwordTxt, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 80)
        let ptCenterX = NSLayoutConstraint(item: passwordTxt, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let ptHeight = NSLayoutConstraint(item: passwordTxt, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: 30)
        let ptWidth = NSLayoutConstraint(item: passwordTxt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 200)
        
        passwordTxt.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([ptCentreY, ptCenterX, ptHeight, ptWidth])
        
        let logCenterY = NSLayoutConstraint(item: loginBtn, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 160)
        let logCenterX = NSLayoutConstraint(item: loginBtn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let logHeight = NSLayoutConstraint(item: loginBtn, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: 30)
        let logWidth = NSLayoutConstraint(item: loginBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 100)
        
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([logCenterY, logCenterX, logHeight, logWidth])
        
        let rpCenterY = NSLayoutConstraint(item: forgotLbl, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 220)
        let rpCenterX = NSLayoutConstraint(item: forgotLbl, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let rpHeight = NSLayoutConstraint(item: forgotLbl, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: 30)
        let rpWidth = NSLayoutConstraint(item: forgotLbl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 200)
        
        forgotLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([rpCenterY, rpCenterX, rpHeight, rpWidth])
        
        let aivCenterY = NSLayoutConstraint(item: loginAIV, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -80)
        let aivCenterX = NSLayoutConstraint(item: loginAIV, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let aivHeight = NSLayoutConstraint(item: loginAIV, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: 100)
        let aivWidth = NSLayoutConstraint(item: loginAIV, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 100)
        
        loginAIV.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([aivCenterY, aivCenterX, aivHeight, aivWidth])
    }
    
}

