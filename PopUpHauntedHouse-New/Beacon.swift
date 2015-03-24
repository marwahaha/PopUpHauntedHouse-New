//
//  Beacon.swift
//  PopUpHauntedHouse-dev
//
//  Created by Mark Harris on 3/19/15.
//  Copyright (c) 2015 Murmur. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Beacon:NSManagedObject {
    
    @NSManaged var beaconId:String!
    @NSManaged var name:String?
    var actions:[ActionProtocol]=[]
    
    init(thisBeaconId:String) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let ctx = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Beacon", inManagedObjectContext: ctx)!
        super.init(entity: entity, insertIntoManagedObjectContext: ctx)
        self.beaconId=thisBeaconId
    }
    
    func addActions(actions:[ActionProtocol]) {
        for a in actions {
        self.addAction(a)
        }
    }
    
    func addAction(action:ActionProtocol) {
        self.actions.append(action)
    }
    
    func addActionAtIndex(action:ActionProtocol,atIndex:Int) {
        self.actions.insert(action, atIndex:atIndex)
    }
    
}
