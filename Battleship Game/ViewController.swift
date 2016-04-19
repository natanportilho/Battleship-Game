//
//  ViewController.swift
//  Battleship Game
//
//  Created by Natan Portilho on 3/20/16.
//  Copyright © 2016 Natan Portilho. All rights reserved.
//https://www.youtube.com/watch?v=UH3HoPar_xg
//

import UIKit
import SocketIOClientSwift

class ViewController: UICollectionViewController {
    @IBOutlet weak var buttonImageView: UIImageView!
    var countTag = 1

    @IBOutlet weak var playerScore: UITextField!

    @IBOutlet weak var adversaryScore: UITextField!
   
    @IBOutlet weak var turn: UITextField!
    override func viewDidAppear(animated: Bool) {

        let isUserLogged = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        
        if (isUserLogged == false){
            self.performSegueWithIdentifier("LoadLoginScreen", sender: self)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSUserDefaults.standardUserDefaults().setObject("natan", forKey: "userLogin")
        NSUserDefaults.standardUserDefaults().setObject("111", forKey: "userPassword")
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        ServerHandler.sharedInstance.connect();
        
        self.adversaryScore.textColor = UIColor.redColor()
        self.playerScore.textColor = UIColor.orangeColor()
        
        
        // This handler was implemented here cuz it's used to change the ViewController state
        ServerHandler.sharedInstance.socket.on("end_game") {    data, ack in
            ServerHandler.sharedInstance.endGame = true
            
            if ("[\(ServerHandler.sharedInstance.myPlayer.name)]" == String(data)){
                // If is wibber the messa on the screen will say the player is a winner, otherwise you say 'you lose'
                ServerHandler.sharedInstance.isWinner = true
            }
            
            ServerHandler.sharedInstance.showEndGameMessage(self)
            
        }
        
        ServerHandler.sharedInstance.socket.on("points_increase") {    data, ack in
            
            // Player made points
            if (String(data) == "[\(ServerHandler.sharedInstance.myPlayer.name)]"){
                ServerHandler.sharedInstance.myPlayer.points += 1
                self.playerScore.text = String(ServerHandler.sharedInstance.myPlayer.points + 1)

            }
                // Adversary made points
            else {
                ServerHandler.sharedInstance.myPlayer.adversaryPoints += 1
                self.adversaryScore.text = String(ServerHandler.sharedInstance.myPlayer.adversaryPoints)

            }
        }
        
        ServerHandler.sharedInstance.socket.on("turn"){    data, ack in
     
            if (String(data) == "\(ServerHandler.sharedInstance.myPlayer.name)" || String(data) == "[\(ServerHandler.sharedInstance.myPlayer.name)]"){
                self.turn.text = "Your turn"
                self.view.userInteractionEnabled = true
            }else{
                self.view.userInteractionEnabled = false
                self.turn.text = "Adv. turn"

            }
        }
       
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        
        
        
        // Creates a button programatically inside each cell, also, each button has its own tag
        let button   = UIButton(type: UIButtonType.System) as UIButton
       
        button.frame = CGRectMake(0, 0 , 80 , 80);
        button.tag = countTag
        countTag = countTag + 1
        button.addTarget(self, action: "onClickCell:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // adds created button to cell
        cell.addSubview(button)
        return cell
        
    }

    
    //Shows button image when button is clicked
    @IBAction func onClickCell(sender: UIButton) {
       ServerHandler.sharedInstance.turn(ServerHandler.sharedInstance.myPlayer.name)
        
        
        let image0 = UIImage(named: "white_ship.png")
        let image1 = UIImage(named: "miss.png")

        print(" Button with tag \(sender.tag) pressed")
        
        let isAShip = ServerHandler.sharedInstance.play(sender.tag)
        print("DEBUG: onClickCell() - play() already returned something")
        
        if (isAShip){
            sender.setImage(image0, forState: .Normal)
            sender.enabled = false
            
        } else{
            sender.setImage(image1, forState: .Normal)
        }
        
        sender.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        
    }
    
    
}



