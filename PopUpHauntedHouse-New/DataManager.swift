//
//  JSONManager.swift
//  PopUpHauntedHouse-dev
//
//  Created by Mark Harris on 3/20/15.
//  Copyright (c) 2015 Murmur. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataManager {
    
    class func setUpActions() {
        DataManager.getJSONDataFromFile("PopUpHauntedHouse")
    }
    
    class func getJSONDataFromFile(fileName:String)->Void {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
                let filePath = NSBundle.mainBundle().pathForResource(fileName,ofType:"json")
                var readError:NSError?
            
                if let data = NSData(contentsOfFile:filePath!,options: NSDataReadingOptions.DataReadingUncached,error:&readError) {
            
                    let json = JSON(data: data)
                    println(json)
                    if let appArray = json["data"].arrayValue {
                        
                        for appDict in appArray {
                            var beaconId:String = appDict["id"].stringValue!
                            var actionsArray:Array<JSON> = appDict["actions"].arrayValue!
                            
                            for action in actionsArray {
                                if (action["type"].stringValue!=="AudioTrack") {
                                    DataManager.saveTypeAudioTrack(beaconId,action:action)
                                }
                            }
                        }
                        
                    }
                    
                }
            
            })
    }
    
    class func saveTypeAudioTrack(beaconId:String,action:JSON) {
        
        var actions:[String:String] = [String:String]()
        var name:String = action["name"].stringValue!
        var actionString:String = action["actionstring"].stringValue!
        var actionStringArray = split(actionString) {$0 == "."}
        var audioFile:String = actionStringArray[0]
        var audioExtension:String = actionStringArray[1]
        var order:NSNumber = action["order"].numberValue!
        
        self.saveAudioTrack(beaconId,name:name,audioFile:audioFile, audioExtension:audioExtension,order:order)
    }
    
    class func saveAudioTrack(beaconId:String,name:String,audioFile:String,audioExtension:String,order:NSNumber) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("AudioTrack",inManagedObjectContext:managedContext)
        let action = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:managedContext)
        
        action.setValue(beaconId, forKey: "beaconId")
        action.setValue(name, forKey: "name")
        action.setValue(audioFile, forKey: "audioFile")
        action.setValue(audioExtension, forKey: "audioExtension")
        action.setValue(order, forKey: "order")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
    }
    
    class func getAudioTracksForBeacon(beaconId:String)->Array<NSManagedObject> {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"AudioTrack")
        
        let predicate = NSPredicate(format: "beaconId == %@", beaconId)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest,error: &error) as [NSManagedObject]?
        
        var actions:[NSManagedObject] = [NSManagedObject]()
        if let results = fetchedResults {
            actions = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        return actions;
    }
    
}
