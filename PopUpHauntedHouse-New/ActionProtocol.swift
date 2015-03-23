//
//  ActionProtocol.swift
//  PopUpHauntedHouse-dev
//
//  Created by Mark Harris on 3/19/15.
//  Copyright (c) 2015 Murmur. All rights reserved.
//

import Foundation

/**
name
type
actionString - audioFile, URL, etc.
order
*/
protocol ActionProtocol {
    //var order: NSNumber! { get set }
    func setUpAction()
    func performAction()
}