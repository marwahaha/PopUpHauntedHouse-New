//
//  Beacon.swift
//  PopUpHauntedHouse-dev
//
//  Created by Mark Harris on 3/19/15.
//  Copyright (c) 2015 Murmur. All rights reserved.
//

import Foundation

class Beacon {
    
    var beaconId:String!
    var actions:[ActionProtocol]!
    
    init(thisBeaconId:String) {
        self.beaconId=thisBeaconId
    }
    init(thisBeaconId:String,theseActions:[ActionProtocol]) {
        self.beaconId = thisBeaconId
        self.actions = theseActions
    }
    
    func addAction(action:ActionProtocol) {
        self.actions.append(action)
    }
    
    func addActionAtIndex(action:ActionProtocol,atIndex:Int) {
        self.actions.insert(action, atIndex:atIndex)
    }
    
}
