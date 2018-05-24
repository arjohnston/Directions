//
//  LocationsWindow.swift
//  Directions
//
//  Created by Andrew Johnston on 5/19/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import Cocoa

protocol LocationsWindowDelegate {
    func locationsDidUpdate()
}

class LocationsWindow: NSWindowController, NSWindowDelegate, NSTableViewDataSource {
    
    let label:[String] = ["Home", "Work"]
    let address:[String] = ["San Jose, CA", "San Francisco, CA"]

    @IBOutlet weak var originTextField: NSTextField!
    @IBOutlet weak var destinationTextField: NSTextField!
    @IBOutlet weak var apiKeyTextField: NSTextField!
    
    var delegate: LocationsWindowDelegate?
    
    override var windowNibName : NSNib.Name! {
        return NSNib.Name("LocationsWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)

        let defaults = UserDefaults.standard
        let origin = defaults.string(forKey: "origin") ?? DEFAULT_ORIGIN
        let destination = defaults.string(forKey: "destination") ?? DEFAULT_DESTINATION
        originTextField.stringValue = origin
        destinationTextField.stringValue = destination
    }

    
    func windowWillClose(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.setValue(originTextField.stringValue, forKey: "origin")
        defaults.setValue(destinationTextField.stringValue, forKey: "destination")
        
        delegate?.locationsDidUpdate()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return label.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableColumn?.identifier.rawValue == "label" {
            return label[row]
        } else {
            return address[row]
        }
    }
}


