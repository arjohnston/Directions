//
//  PreferencesWindow.swift
//  Directions
//
//  Created by Andrew Johnston on 5/19/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import Cocoa

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindow: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var originTextField: NSTextField!
    @IBOutlet weak var destinationTextField: NSTextField!
    @IBOutlet weak var apiKeyTextField: NSTextField!
    
    var delegate: PreferencesWindowDelegate?
    
    override var windowNibName : NSNib.Name! {
        return NSNib.Name("PreferencesWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)

        let defaults = UserDefaults.standard
        let origin = defaults.string(forKey: "origin") ?? DEFAULT_ORIGIN
        let destination = defaults.string(forKey: "destination") ?? DEFAULT_DESTINATION
        let apiKey = defaults.string(forKey: "apiKey") ?? ""
        originTextField.stringValue = origin
        destinationTextField.stringValue = destination
        apiKeyTextField.stringValue = apiKey
    }
    
    func windowWillClose(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.setValue(originTextField.stringValue, forKey: "origin")
        defaults.setValue(destinationTextField.stringValue, forKey: "destination")
        defaults.setValue(apiKeyTextField.stringValue, forKey: "apiKey")
        
        delegate?.preferencesDidUpdate()
    }
}
