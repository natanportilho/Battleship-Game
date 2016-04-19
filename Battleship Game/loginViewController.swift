//
//  loginViewController.swift
//  Battleship Game
//
//  Created by Natan Portilho on 3/29/16.
//  Copyright © 2016 Natan Portilho. All rights reserved.
//
import UIKit
import SocketIOClientSwift

class loginViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("LoadLoginScreen", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServerHandler.sharedInstance.connect();
        
    }
    
    func login(){
    
    }
    
    
}

