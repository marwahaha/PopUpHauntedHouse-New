//
//  ViewController.swift
//  PopUpHauntedHouse-dev
//
//  Created by Mark Harris on 3/12/15 for Murmur

import UIKit
import CoreData

class ViewController: UIViewController, ESTBeaconManagerDelegate {
    
    /**
    This system needs a few things:
    
    1) Type of action(s): PLAY_AUDIO, SEND MESSAGE TO SERVER. It would be nice if each "Track" could fire off multiple actions. So that is another object, not just AudioTrack.
    
    2) Timeline: Have you been to this beacon before and what happened then? So this way we can create an actual story.
    Or, at the very least give some variation based on how many times you revisit a specific place. This is where the story
    comes in.
    
    So if we have an array of possible actions. And right now, we assume they are not time-based, but purely location-based,
    then we only need to know which action is associated with which beacon, and which action comes first for that beacon.
    
    Or we can randomize. But right now, let's think about a non-linear story in that you can visit any beacon, but linear in the sense that each beacon has a chronology.
    
    So we need a data structure for beacons. A key beacon id, and a SortedSet of ActionProtocols
    
    3) Some kind of intro on screen, in audio, something.
    
    4) A way to program stories and beacons (phase 2)
    */
    
    let uuIDString:String = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
    let proximityUUID:NSUUID = NSUUID(UUIDString:"B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
    let beaconManager:ESTBeaconManager =  ESTBeaconManager()
    
    var beacons:Dictionary<String,Beacon>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()
        var beaconRegion:ESTBeaconRegion = ESTBeaconRegion(proximityUUID:proximityUUID,identifier:"Estimotes")
        beaconManager.startRangingBeaconsInRegion(beaconRegion)*/

        //DataManager.setUpActions();
        var beaconId:String = "B9407F30-F5F8-466E-AFF9-25556B57FE6D-5153-14990";
        var actions:[NSManagedObject] = DataManager.getAudioTracksForBeacon(beaconId);
        for action in actions {
            var name:String = action.valueForKey("name") as String!
            var order:NSNumber = action.valueForKey("order") as NSNumber!
            println("name: \(name) : order: \(order)")
        }
    }
    
    /**
    
    */
    func beaconManager(manager: ESTBeaconManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: ESTBeaconRegion!) {
        for var i=0; i<beacons.count; i++ {
            println("prox: \(beacons[i].minor) : \(beacons[i].rssi) : \(beacons[i].proximity.rawValue)")
            var beacon = beacons[i] as ESTBeacon
            var majorString = String(beacon.major.integerValue)
            var minorString = String(beacon.minor.integerValue)
            var slug:String = uuIDString+"-"+majorString+"-"+minorString
            
            // GRAB THE NEXT ONE IN THE LIST
            //var thisTrack:ActionProtocol =  beacons[slug]
            //if (beacon.proximity.rawValue == 1) {
            //    thisTrack.performAction()
            //}
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}