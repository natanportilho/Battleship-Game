//
//  Player.swift
//  Battleship Game
//
//  Created by Natan Portilho on 4/4/16.
//  Copyright © 2016 Natan Portilho. All rights reserved.
//

import Foundation

class Player {
    // class definition goes here
    var name:String
    var points:Int
    var adversaryPoints:Int
    
    init(name:String, points:Int) {
        // perform some initialization here
        self.name = name
        self.points = 0
        self.adversaryPoints = 0
    }
}
