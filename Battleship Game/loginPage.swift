//
//  loginPage.swift
//  Battleship Game
//
//  Created by Natan Portilho on 3/20/16.
//  Copyright © 2016 Natan Portilho. All rights reserved.
//
//https://www.youtube.com/watch?v=a5pzlbBnfYg
//https://www.youtube.com/watch?v=PKOswUE731c
/* Represents the login page, the first page which will appear in case the user is not already logged */
import UIKit
import SocketIOClientSwift

class loginPage: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func buttonLogin(sender: AnyObject) {
        let user = String(userName.text!)
        let pw = String(password.text!)
        
        let userLoginStored = NSUserDefaults.standardUserDefaults().stringForKey("userLogin")
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
        
        if (user == userLoginStored && pw == userPasswordStored){
            // Login is successfull
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.dismissViewControllerAnimated(true, completion:nil)
        }
        
        ServerHandler.sharedInstance.sendLogin(user, password: pw)
    }

    
}
