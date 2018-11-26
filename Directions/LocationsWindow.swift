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
//    let label: [String] = UserDefaults.standard.array(forKey: "label") as? [String] ?? ["Home", "Work"]
//    let address: [String] = UserDefaults.standard.array(forKey: "address") as? [String] ?? ["San Jose, CA", "San Francisco, CA"]
    let tableViewData = [["firstName":"John","lastName":"Doe","emailId":"john.doe@knowstack.com"],["firstName":"Jane","lastName":"Doe","emailId":"jane.doe@knowstack.com"]]

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
//        defaults.setValue(label, forKey: "label")
//        defaults.setValue(address, forKey: "address")
        
        delegate?.locationsDidUpdate()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
//        return label.count
        return tableViewData.count
    }

//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        if tableColumn?.identifier.rawValue == "label" {
//            return label[row]
//        } else {
//            return address[row]
//        }
//    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        var result:NSTableCellView
        result = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
//        result.textField?.stringValue = tableViewData[row][(tableColumn?.identifier)!]!
        return result
    }
    
//    @IBAction func addRow(_ sender: Any) {
//        tableView.beginUpdates()
//        tableView.insertRows(at: IndexSet(integer: values.count - 1), withAnimation: .effectFade)
//        tableView.endUpdates()
//    }
}


