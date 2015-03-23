//
//  AudioTrack.swift
//  PopUpHauntedHouse
//
//  Created by Mark Harris on 3/14/15 for Murmur

import Foundation
import AVFoundation
import CoreData
import UIKit

class AudioTrack:NSManagedObject,AVAudioPlayerDelegate,ActionProtocol {
    
    @NSManaged var beaconId:String!
    @NSManaged var name:String!
    @NSManaged var audioFile:String!
    @NSManaged var audioExtension:String!
    @NSManaged var order:NSNumber!
    var isPlaying=false
    var myAudioPlayer:AVAudioPlayer?
    
    
    init(beaconId:String,name:String,audioFile:String,audioExtension:String?,order:Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let ctx = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("AudioTrack", inManagedObjectContext: ctx)!
        super.init(entity: entity, insertIntoManagedObjectContext: ctx)
        self.beaconId=beaconId
        self.name = name
        self.audioFile=audioFile
        self.audioExtension=audioExtension
        self.order = order
    }
    
    func audioPlayerDidFinishPlaying(AVAudioPlayer!, successfully: Bool) {
        self.isPlaying=false
    }
    
    func performAction() {
        if self.isPlaying==false {
            self.myAudioPlayer?.play()
            self.isPlaying=true
        }
    }
    
    func setUpAction()  {
        var path = NSBundle.mainBundle().pathForResource(self.audioFile, ofType:self.audioExtension)
        println(self.audioFile)
        var url = NSURL.fileURLWithPath(path!)
        var error: NSError?
        self.myAudioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        self.myAudioPlayer?.volume = 0.25
        self.myAudioPlayer?.delegate=self
        self.myAudioPlayer?.prepareToPlay()
    }

}