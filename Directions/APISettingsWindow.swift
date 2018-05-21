//
//  APISettingsWindow.swift
//  Directions
//
//  Created by Andrew Johnston on 5/19/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import Cocoa

protocol APISettingsWindowDelegate {
    func APISettingsDidUpdate()
}

class APISettingsWindow: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var travelModeSelection: NSPopUpButton!
    @IBOutlet weak var tollsCheckbox: NSButton!
    @IBOutlet weak var highwayCheckbox: NSButton!
    @IBOutlet weak var ferriesCheckbox: NSButton!
    @IBOutlet weak var timeModeSelection: NSPopUpButton!
    @IBOutlet weak var timeSelection: NSDatePicker!
    @IBOutlet weak var departNowCheckbox: NSButton!
    @IBOutlet weak var apiKeyTextField: NSTextField!
    @IBOutlet weak var updateIntervalSelection: NSPopUpButton!
    
    @IBAction func timeModeSelected(_ sender: NSPopUpButton) {
        let mode = timeModeSelection.indexOfSelectedItem
        let defaults = UserDefaults.standard
        
        if mode == 1 {
            departNowCheckbox.isEnabled = false
            
            timeSelection.isEnabled = true
            timeSelection.textColor = .black
        } else {
            departNowCheckbox.isEnabled = true
            
            if defaults.integer(forKey: "departNow") == 1 {
                timeSelection.isEnabled = false
                timeSelection.textColor = .gray
            }
        }
    }

    @IBAction func departNowClicked(_ sender: NSButton) {
        let defaults = UserDefaults.standard
        defaults.setValue(departNowCheckbox.state.rawValue, forKey: "departNow")
        
        if defaults.integer(forKey: "departNow") == 1 {
            timeSelection.isEnabled = false
            timeSelection.textColor = .gray
        } else {
            timeSelection.isEnabled = true
            timeSelection.textColor = .black
        }
    }
    
    @IBAction func helpButtonClicked(_ sender: Any) {
        apiSettingsHelpWindow.showWindow(nil)
    }
    
    
    var delegate: APISettingsWindowDelegate?
    
    override var windowNibName : NSNib.Name! {
        return NSNib.Name("APISettingsWindow")
    }
    
    var apiSettingsHelpWindow: APISettingsHelpWindow!
    
    override func awakeFromNib() {
        apiSettingsHelpWindow = APISettingsHelpWindow()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
        
        let defaults = UserDefaults.standard
        let intervalTime = defaults.integer(forKey: "intervalTime")
        let travelMode = defaults.integer(forKey: "travelMode")
        let tolls = defaults.integer(forKey: "tolls")
        let highway = defaults.integer(forKey: "highway")
        let ferries = defaults.integer(forKey: "ferries")
        let timeMode = defaults.integer(forKey: "timeMode")
        let departNow = defaults.integer(forKey: "departNow")
        let apiKey = defaults.string(forKey: "apiKey") ?? ""

        updateIntervalSelection.selectItem(at: intervalTime)
        travelModeSelection.selectItem(at: travelMode)
        tollsCheckbox.state = NSControl.StateValue(tolls)
        highwayCheckbox.state = NSControl.StateValue(highway)
        ferriesCheckbox.state = NSControl.StateValue(ferries)
        timeModeSelection.selectItem(at: timeMode)
        departNowCheckbox.state = NSControl.StateValue(departNow)
        apiKeyTextField.stringValue = apiKey
        
        if let timeSelected = defaults.object(forKey: "timeSelected") as? Date {
            timeSelection.dateValue = timeSelected
        }
        
        if defaults.integer(forKey: "departNow") == 1 {
            timeSelection.isEnabled = false
            timeSelection.textColor = .gray
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.setValue(updateIntervalSelection.indexOfSelectedItem, forKey: "intervalTime")
        defaults.setValue(travelModeSelection.indexOfSelectedItem, forKey: "travelMode")
        defaults.setValue(tollsCheckbox.state.rawValue, forKey: "tolls")
        defaults.setValue(highwayCheckbox.state.rawValue, forKey: "highway")
        defaults.setValue(ferriesCheckbox.state.rawValue, forKey: "ferries")
        defaults.setValue(timeModeSelection.indexOfSelectedItem, forKey: "timeMode")
        defaults.setValue(departNowCheckbox.state.rawValue, forKey: "departNow")
        defaults.setValue(apiKeyTextField.stringValue, forKey: "apiKey")
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        let hours = calendar.component(.hour, from: timeSelection.dateValue)
        let minutes = calendar.component(.minute, from: timeSelection.dateValue)
        
        let date = calendar.date(bySettingHour: hours, minute: minutes, second: 0, of: now as Date, options: NSCalendar.Options.matchFirst)!
        
        defaults.setValue(date, forKey: "timeSelected")
        
        delegate?.APISettingsDidUpdate()
    }

}
