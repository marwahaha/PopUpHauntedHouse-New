//
//  MediaManager.swift
//  PopUpHauntedHouse-New
//
//  Created by Mark Harris on 3/31/15.
//  Copyright (c) 2015 Murmur. All rights reserved.
//

import Foundation
import AlamoFire

class MediaManager {
    
    class func downloadMedia(url:String) {
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        
        Alamofire.download(.GET, url, destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                println(totalBytesRead)
            }
            .response { (request, response, _, error) in
                println(response)
        }

    }
}
