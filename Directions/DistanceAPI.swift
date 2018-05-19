//
//  DistanceAPI.swift
//  Directions
//
//  Created by Andrew Johnston on 5/16/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

// API Console for Distance Matrix API
// https://console.cloud.google.com

import Foundation

struct DurationInTraffic: CustomStringConvertible {
    var time: String
    
    var description: String {
        return "\(time)"
    }
}

class DistanceAPI {
    let BASE_URL = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&departure_time=now"
    
    func fetchDistance(origin: String, destination: String, success: @escaping (DurationInTraffic) -> Void) {
        let session = URLSession.shared
        let defaults = UserDefaults.standard
        let API_KEY = defaults.string(forKey: "apiKey") ?? ""
        let escapedOrigin = origin.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let escapedDestination = destination.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: "\(BASE_URL)&origins=\(escapedOrigin!)&destinations=\(escapedDestination!)&key=\(API_KEY)")
        
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
    
    func distanceFromJSONData(_ data: Data) -> DurationInTraffic? {
        typealias JSONDict = [String:AnyObject]
        let json : JSONDict
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        var distanceList = json["rows"] as! [JSONDict]
        let distanceDict = distanceList[0]["elements"] as! [JSONDict]
        let x = distanceDict[0]
        let distanceInText = x["duration_in_traffic"]!["text"]
        
        let distance = DurationInTraffic(time: distanceInText as! String)

        return distance
    }
}
