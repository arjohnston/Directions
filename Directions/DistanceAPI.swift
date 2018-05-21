//
//  DistanceAPI.swift
//  Directions
//
//  Created by Andrew Johnston on 5/16/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

// API Console for Directions Matrix API
// https://console.cloud.google.com

import Foundation

struct DurationInTraffic: CustomStringConvertible {
    var time: String
    
    var description: String {
        return "\(time)"
    }
}

class DistanceAPI {
    let BASE_URL = "https://maps.googleapis.com/maps/api/directions/json?units=imperial"
    
    func fetchDistance(origin: String, destination: String, success: @escaping (DurationInTraffic) -> Void) {
        let session = URLSession.shared
        let defaults = UserDefaults.standard
        let API_KEY = defaults.string(forKey: "apiKey") ?? ""
        let escapedOrigin = origin.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let escapedDestination = destination.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let options = getOptions()
        let url = URL(string: "\(BASE_URL)\(options)&origin=\(escapedOrigin!)&destination=\(escapedDestination!)&key=\(API_KEY)")
        
        if API_KEY == "" {
            return
        }
        
        let task = session.dataTask(with: url!) { data, response, err in
            if let error = err {
                NSLog("distance API error: \(error)")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let distance = self.distanceFromJSONData(data!) {
                        success(distance)
                    }
                    
                case 401:
                    NSLog("distance API return Unathorized. Did you set your API key?")
                
                default:
                    NSLog("distance API return response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    func getOptions() -> String {
        var options: String = ""
        let defaults = UserDefaults.standard
        let isEnabled = 1
    
        // Departure or Arrival time.
        // Default: "now"
        let departNow = defaults.integer(forKey: "departNow")
        let timeSelected = defaults.object(forKey: "timeSelected") as? Date
        var travelTime = defaults.integer(forKey: "timeMode") == 1 ? "&arrival_time=" : "&departure_time="
        
        if departNow == isEnabled {
            travelTime += "now"
        } else {
            // Specify the time as an integer in seconds since midnight, January 1, 1970 UTC.
            travelTime += String(Int(timeSelected!.timeIntervalSince1970))
        }
        
        options += travelTime
        
        
        // Travel mode
        // Driving, Walking, Bicycle, Transit
        // Default: driving
        let travelMode = defaults.integer(forKey: "travelMode")
        var travel = "driving"
        
        switch  travelMode {
            case 1:
                travel = "walking"
            case 2:
                travel = "bicycling"
            case 3:
                travel = "transit"
            default:
                travel = "driving"
        }
        
        options += "&mode=\(travel)"
        
        
        // Avoidance
        // Tolls, Highways, Ferries
        // Default: none
        let tolls = defaults.integer(forKey: "tolls")
        let highway = defaults.integer(forKey: "highway")
        let ferries = defaults.integer(forKey: "ferries")
        var avoidance = "&avoid="
        
        if (tolls + highway + ferries) > 0 {
            if tolls == isEnabled {
                avoidance += "tolls"
            }
            
            if highway == isEnabled {
                if tolls == isEnabled {
                    avoidance += "|highways"
                } else {
                    avoidance += "highways"
                }
            }
            
            if ferries == isEnabled {
                if highway == isEnabled || highway != isEnabled && tolls == isEnabled {
                    avoidance += "|ferries"
                } else {
                    avoidance += "ferries"
                }
            }
            
            options += avoidance
        }
        
        return options.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    func distanceFromJSONData(_ data: Data) -> DurationInTraffic? {
        let defaults = UserDefaults.standard
        let driving = defaults.integer(forKey: "travelMode") == 0
        let typeOfTime = defaults.integer(forKey: "timeMode") == 0 ? "departure" : "arrival"
        typealias JSONDict = [String:AnyObject]
        let json : JSONDict
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        let jsonData = json["routes"] as! [JSONDict]
        let legs = jsonData[0]["legs"] as! [JSONDict]
        
        if var summary = jsonData[0]["summary"] as? String {
            if summary != "" {
                summary += " - "
            }
        }
        
        var summary = jsonData[0]["summary"] as! String
        if summary != "" {
            summary += " - "
        }
        
        var duration = ""
        if driving && typeOfTime == "departure" {
            if let dur = legs[0]["duration_in_traffic"]?["text"] as? String {
                duration = dur
            }
            
        } else {
            if let dur = legs[0]["duration"]?["text"] as? String {
                duration = dur
            }
        }
        
        return DurationInTraffic(time: "\(summary)\(duration)")
    }
}
