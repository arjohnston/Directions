//
//  statusMenuController.swift
//  Directions
//
//  Created by Andrew Johnston on 5/12/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import Cocoa

class statusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    
    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        // Enable this for White / Block icons in dark / normal modes
        // icon?.isTemplate = true
        
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
}
