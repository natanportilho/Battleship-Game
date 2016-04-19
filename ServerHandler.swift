//
//  ServerHandler.swift
//  Battleship Game
//
//  Created by Natan Portilho on 3/21/16.
//  Copyright © 2016 Natan Portilho. All rights reserved.
//

/*Singleton created to manage all the server connection*/

import Foundation
import SocketIOClientSwift

private let server = ServerHandler()

class ServerHandler{
    let socket = SocketIOClient(socketURL: NSURL(string: "http://localhost:8900")!,  options: [.Log(true), .ForcePolling(true), .ConnectParams(["token" : "my-auth-token"])])
    
    var tableGame = [Int]()
    var counter = 0
    var endGame = false
    var myPlayer = Player(name: "", points: 0)
    var player = " " // Represents instance of Player. Can be player 1 or player 2
    var isWinner = false
    
    // Singleton
    class var sharedInstance: ServerHandler {
        return server
    }
    
    // Constructor
    init(){
        self.addHandlers()
    }
    
    func connect(){
        self.socket.connect()
    }
    
    func disconnect(){
        self.socket.disconnect()
    }
    
    func isConnected() -> Bool{
        if String(self.socket.status) == "Connected"{
            return true
        }
        return false
    }
    
    func sendLogin(username:String, password:String){
        self.socket.emit("login", username)
        self.socket.emit("rollADie") // rolls a die to see who starts the game
    }
    
    func addHandlers(){
        socket.on("connect") {  data, ack in
            self.socket.emit("message", "CLIENT: Client connected to server.")
        }
        
        socket.on("sendTableToClient") {    data, ack in
            print("CLIENT: Received table from server.");
            print("SERVER: \(data)")
            self.tableGame.append(Int(data[0] as! NSNumber))
        }
        
        socket.on("loginSuccess") {    data, ack in
            print("SERVER: \(data)")
        }
        
        socket.on("loginFail") {    data, ack in
            print("SERVER: \(data)")
        }

        // Gets player's name
        socket.on("player") {    data, ack in
            self.myPlayer.name = String(data)
        }
    }
    
    // Finction to change turn
    func turn(playerName:String){
         self.socket.emit("turn", playerName)
    }
    
    // Returns true if player hits a ship, returns false otherwise
    func play(tagButtonpressed:Int) -> Bool{
        
        // First check wether the button pressed is a ship or not
        for i in tableGame {

            // var i it is NOT an index, i is the value in the index
            if (tagButtonpressed == i){
             //   self.socket.emit("points_increase", self.myPlayer.name)
                
                ///
                socket.emitWithAck("points_increase", self.myPlayer.name)(timeoutAfter: 0) {data in
                    
                }
                print("DEBUG: play() returning true")
                return true
            }
        }
    return false
    }
    
    // This method is designed to show a message at the main screen when the game is over
    func showEndGameMessage(viewController:UICollectionViewController){
        let alert:UIAlertController
        
        if (self.isWinner == true){
                 alert = UIAlertController(title: "End Game", message: "You WIN! :)", preferredStyle: UIAlertControllerStyle.Alert)
        } else{
            alert = UIAlertController(title: "End Game", message: "You LOSE! :(", preferredStyle: UIAlertControllerStyle.Alert)
        }
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func didGameEnd() -> Bool{
        return self.endGame
    }
    
}
