//
//  APISettingsHelpWindow.swift
//  Directions
//
//  Created by Andrew Johnston on 5/20/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import Cocoa

class APISettingsHelpWindow: NSWindowController {
    override var windowNibName : NSNib.Name! {
        return NSNib.Name("APISettingsHelpWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
