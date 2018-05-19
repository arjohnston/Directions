//
//  StatusMenuController.swift
//  Directions
//
//  Created by Andrew Johnston on 5/12/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import Cocoa

let DEFAULT_ORIGIN = "San Jose, CA"
let DEFAULT_DESTINATION = "San Francisco, CA"

class StatusMenuController: NSObject, PreferencesWindowDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let distanceAPI = DistanceAPI()
    
    var preferencesWindow: PreferencesWindow!
    
    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
         icon?.isTemplate = true // Disable to have original image color
        
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self
        
        updateDistance()
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
    
    func updateDistance() {
        let defaults = UserDefaults.standard
        distanceAPI.fetchDistance(
            origin: defaults.string(forKey: "origin") ?? DEFAULT_ORIGIN,
            destination: defaults.string(forKey: "destination") ?? DEFAULT_DESTINATION,
            success: { distance in
                DispatchQueue.main.async {
                    self.statusItem.title = distance.description
                }
        })
    }
    
    @IBAction func updateClicked(_ sender: NSMenuItem) {
        updateDistance()
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func preferencesDidUpdate() {
        updateDistance()
    }
}
