//
//  MediaManager.swift
//  PopUpHauntedHouse-New
//
//  Created by Mark Harris on 3/31/15.
//  Copyright (c) 2015 Murmur. All rights reserved.
//

import Foundation

class MediaManager {
    
    class func downloadMedia(actionName:String,url:String) {
        
        var fileUUID = NSUUID().UUIDString
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
            (temporaryURL, response) in
            
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                
                var returnUrl:NSURL = directoryURL.URLByAppendingPathComponent("\(fileUUID).\(response.suggestedFilename)")
                println("Action Name: \(actionName)");
                var fileSaved = DataManager.saveFilePathForAudioTrack(actionName,path:returnUrl.path!);
                println(fileSaved)
                
                return returnUrl
            }
        
            
            return temporaryURL
        }

    }
}
