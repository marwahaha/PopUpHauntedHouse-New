//
//  ViewController.swift
//  PopUpHauntedHouse-dev
//
//  Created by Mark Harris on 3/12/15 for Murmur

import UIKit
import CoreData
import AVFoundation

class ViewController: UIViewController, ESTBeaconManagerDelegate,QRCodeReaderViewControllerDelegate {
    
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
    */
    
    let beaconManager:ESTBeaconManager =  ESTBeaconManager()
    var beaconRegion:CLBeaconRegion!
    var actions:[String:[ActionProtocol]]=[String:[ActionProtocol]]()
    var uuIDString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()        
    }
    
    func setUpBeaconRanging() {
        if let uuidstring = DataManager.getConfigInfo("uuidstring") {
             self.uuIDString=uuidstring
             println("setUpBeaconRanging: "+self.uuIDString!);
             self.beaconRegion = CLBeaconRegion(proximityUUID:NSUUID(UUIDString: self.uuIDString!),identifier:"Estimotes")
            self.startRangingBeacons()
        } else {
            println("problem with UUIDSTRING!")
        }
    }
    
    @IBAction func stopRangeBeacons(sender: AnyObject) {
        self.stopRangingBeacons()
    }
    
    @IBAction func rangeBeacons(sender: AnyObject) {
        if let region = self.beaconRegion {
            self.startRangingBeacons()
        } else {
            self.setUpBeaconRanging()
        }
    }
    @IBAction func loadDataFromURL(sender: AnyObject) {
        DataManager.loadDataFromURL(DataManager.getConfigInfo("configURL")!)
    }
    
    @IBAction func launchQRCodeReader(sender: AnyObject) {
        println("we are now launching the reader")
        var reader = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        reader.delegate=self
        reader.modalPresentationStyle = .FormSheet
        presentViewController(reader, animated: true, completion: nil)
    }
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: String) {
        println("RESULT: "+result);
        DataManager.saveConfigInfo("configURL", configVal: result)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        println("cancelled!");
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshActionsDB() {
        //DataManager.setUpActions(self.jsonConfigURL);
    }
    
    func stopRangingBeacons() {
        println("stopRangingBeacons: "+self.uuIDString!);
        beaconManager.stopRangingBeaconsInRegion(beaconRegion)
    }
    
    func startRangingBeacons() {
        println("startRangingBeacons: "+self.uuIDString!);
        beaconManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func loadBeaconsIntoMemory() {
        var bs:[NSManagedObject] = DataManager.getAllBeacons()
        for b in bs {
            var myBeacon:Beacon = Beacon(thisBeaconId: b.valueForKey("beaconId") as String!)
            self.actions[myBeacon.beaconId]=self.getAudioTracks(myBeacon.beaconId)
        }
    }
    
    func getAudioTracks(beaconId:String)->[ActionProtocol] {
        var actionProtocols:[ActionProtocol] = []
        var actions:[NSManagedObject] = DataManager.getAudioTracksForBeacon(beaconId);
        for action in actions {
            
            var a:AudioTrack=AudioTrack(
                beaconId:beaconId,
                name:action.valueForKey("name") as String!,
                audioFile:action.valueForKey("audioFile") as String!,
                audioExtension:action.valueForKey("audioExtension") as String!,
                order:action.valueForKey("order") as Int!)
            
            actionProtocols.append(a)
        }
        return actionProtocols;
    }
    
    /**
    */
    func beaconManager(manager: ESTBeaconManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        for var i=0; i<beacons.count; i++ {
            
            println("prox: \(beacons[i].minor) : \(beacons[i].rssi) : \(beacons[i].proximity.rawValue)")
            
            var beacon = beacons[i] as CLBeacon
            var majorString = String(beacon.major.integerValue)
            var minorString = String(beacon.minor.integerValue)
            var slug:String = self.uuIDString!+"-"+majorString+"-"+minorString
            
            // GRAB THE NEXT ONE IN THE LIST
            if var actionProtocols = self.actions[slug] {
                
                var thisTrack:ActionProtocol =  actionProtocols[0]
                if (beacon.proximity.rawValue == 1) {
                    //thisTrack.performAction()
                    // TODO: FIGURE OUT RULES FOR UPDATING WHAT WAS DONE AND MOVING THROUGH LIST
                    // Thsi action has happened, it's done. Or just mark it as happened and save?
                    //actionProtocols.removeAtIndex(0)
                }
                
            } else {
                
            }
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}