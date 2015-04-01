//
//  JSONManager.swift
//  PopUpHauntedHouse-dev
//
//  Created by Mark Harris on 3/20/15.
//  Copyright (c) 2015 Murmur. All rights reserved.

//  TODO: Downloading media too. Right now, the config doesn't help that much without the power to download new media with it

import Foundation
import CoreData
import UIKit

class DataManager {
    
    class func loadDataFromURL(url:String) {
        println("loading data from URL: "+url)
        DataManager.storeActionsDataFromURL(url)
    }
    
    class func saveConfigInfo(configKey:String,configVal:String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(configVal, forKey: configKey)
    }
    
    class func getConfigInfo(configKey:String)->String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let val = defaults.stringForKey(configKey) {
            return val;
        }
        return nil
    }
    
    class func storeActionsDataFromURL(urlString:String)->Void {
        // TODO: Move to AlamoFire
        var url = NSURL(string:urlString)!
        var session = NSURLSession.sharedSession()
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                println(responseError)
                //completion(data: nil, error: responseError)
                // TODO: LOG IT AND DEAL WITH IT
            } else if let httpResponse = response as? NSHTTPURLResponse {
                
                    let json = JSON(data: data)
                    println(json)
                
                    if let uuidString = json["uuidstring"].stringValue {
                        DataManager.saveConfigInfo("uuidstring",configVal: uuidString)
                    }
                
                
                    var audioFileDownloadDict = [String:String]()
                    if let appArray = json["data"].arrayValue {
                        
                        for appDict in appArray {
                            var beaconId:String = appDict["id"].stringValue!
                            var beaconName:String = appDict["name"].stringValue!
                            DataManager.saveBeacon(beaconId,name: beaconName);
                            var actionsArray:Array<JSON> = appDict["actions"].arrayValue!
                            
                            for action in actionsArray {
                                if (action["type"].stringValue!=="AudioTrack") {
                                    DataManager.saveTypeAudioTrack(beaconId,action:action)
                                    if let media = action["media"].stringValue {
                                        audioFileDownloadDict[action["name"].stringValue!]=media
                                    }
                                }
                            }
                        }
                    }
                
                // If there are audio files, now save those for each action.
                for actionName in audioFileDownloadDict.keys {
                    println("KEY: \(actionName)")
                    MediaManager.downloadMedia(actionName,url: audioFileDownloadDict[actionName]!);
                }
                
                
            }
        })
        
        loadDataTask.resume()
    }
    
    class func saveFilePathForAudioTrack(actionName:String,path:String)->String {
        var audioTrack:NSManagedObject=DataManager.getAudioTrackForName(actionName)
        audioTrack.setValue(path, forKey: "audioFile")
        DataManager.saveAudioTrack(audioTrack)
        return path
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
    
    class func saveAudioTrack(audioTrack:NSManagedObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("AudioTrack",inManagedObjectContext:managedContext)
        let action = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:managedContext)
        
        /**action.setValue(audioTrack.beaconId, forKey: "beaconId")
        action.setValue(audioTrack.name, forKey: "name")
        action.setValue(audioTrack.audioFile, forKey: "audioFile")
        action.setValue(audioTrack.audioExtension, forKey: "audioExtension")
        action.setValue(audioTrack.order, forKey: "order")*/
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
    }
    
    class func saveBeacon(beaconId:String,name:String) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("Beacon",inManagedObjectContext:managedContext)
        let action = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:managedContext)
        
        action.setValue(beaconId, forKey: "beaconId")
        action.setValue(name, forKey: "name")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
    }
    
    class func getAllBeacons()->Array<NSManagedObject> {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"Beacon")
        
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest,error: &error) as [NSManagedObject]?
        
        var beacons:[NSManagedObject] = [NSManagedObject]()
        if let results = fetchedResults {
            beacons = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        return beacons;
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
    
    class func getAudioTrackForName(name:String)->NSManagedObject {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"AudioTrack")
        
        let predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.predicate = predicate
        
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest,error: &error) as [NSManagedObject]?
        
        var actions:[NSManagedObject] = [NSManagedObject]()
        if let results = fetchedResults {
            actions = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        return actions[0]
    }
    
}
