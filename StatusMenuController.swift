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

class StatusMenuController: NSObject, LocationsWindowDelegate, APISettingsWindowDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var bwIcon: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let distanceAPI = DistanceAPI()
    
    var locationsWindow: LocationsWindow!
    var apiSettingsWindow: APISettingsWindow!
    
    override func awakeFromNib() {
        let defaults = UserDefaults.standard
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        
        // Default to color icon
        icon?.isTemplate = defaults.bool(forKey: "bwIcon")
        bwIcon.state = NSControl.StateValue(defaults.bool(forKey: "bwIcon") == true ? 1 : 0)
        
        
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        locationsWindow = LocationsWindow()
        locationsWindow.delegate = self
        
        apiSettingsWindow = APISettingsWindow()
        apiSettingsWindow.delegate = self
        
        updateDistance()
    }
    
    @IBAction func toggleBWIconClicked(_ sender: NSMenuItem) {
        let defaults = UserDefaults.standard
        let current = defaults.bool(forKey: "bwIcon")
        
        if current == true {
            defaults.setValue(false, forKey: "bwIcon")
            bwIcon.state = NSControl.StateValue(0)
            statusItem.image?.isTemplate = false
        } else {
            defaults.setValue(true, forKey: "bwIcon")
            bwIcon.state = NSControl.StateValue(1)
            statusItem.image?.isTemplate = true
        }
        defaults.setValue(!current, forKey: "bwIcon")
        
        bwIcon.isEnabled = defaults.bool(forKey: "bwIcon")
    }
    
    @IBAction func locationsClicked(_ sender: NSMenuItem) {
        locationsWindow.showWindow(nil)
    }
    
    @IBAction func apiSettingsClicked(_ sender: NSMenuItem) {
        apiSettingsWindow.showWindow(nil)
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
    
    func locationsDidUpdate() {
        updateDistance()
    }
    
    func APISettingsDidUpdate() {
        updateDistance()
    }
}
