//
//  ServerManager.swift
//  findmybusnj
//  Class for handling the server connections to retrieve new time data
//
//  Created by David Aghassi on 12/30/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation

// MARK: Dependencies
import Alamofire
import SwiftyJSON

/**
 Part of the `NetworkManager` framework. Used to make calls to findmybusnj.com server
*/
public class NMServerManager {
    private static let baseURL = "https://findmybusnj.com/rest"
    
    /**
     Get all the buses coming to a given stop. When using this, you need to pass a completion function in to handle the json returned by the server call.
     
     - Parameters:
        - stop: The six digit stop number that the user gets from myBus sign at stop
        - completion: A function to be called back upon success that takes a JSON array and any errors
    */
    public static func getJSONForStop(stop: String, completion: (item: JSON, error: ErrorType?) -> Void) {
        let parameters = [ "stop" : stop ]
        makePOST("/stop", parameters: parameters, completion: completion)
    }
    
    /**
     Get all the buses coming to a given stop, filtered by the bus number. So if the user passes in `165`, the buses returned will only be those that have `165` in the number scheme. This function requires a completion handler so that the json can be handled when called.
     
     - Parameters:
        - stop: The six digit string provided by the myBus stop sign that the user types in
        - bus: The three digit string that defines the bus number to filter on
        - completion: A callback function to handle the JSON data upon a successful request
    */
    public static func getJSONForStopFilteredByBus(stop: String, bus: String, completion: (item: JSON, error: ErrorType?) -> Void) {
        let parameters = [ "stop" : stop, "bus" : bus]
        makePOST("/stopFilteredByBus", parameters: parameters, completion: completion);
    }
    
    /**
     Wrapper function around common `.POST` request call. Used for making post requests that take a string of parameters to go to an endpoint. This function requires a completion handler to handle the JSON once it responds successfully.
     
     - TODO: Better handle failure if JSON is not properly returned
     
     - Parameters:
        - endpoint: String that denotes the endpoint to hit when pinned to the `baseURL`
        - parameters: `[String : String]` of parameters that will be handled when the enpoint is hit
        - completion: The completion function that will be called when the data is succesfully returned
    */
    private static func makePOST(endpoint: String, parameters: [String : String], completion: (item: JSON, error: ErrorType?) -> Void) {
        let url = baseURL + endpoint
        
        Alamofire.request(.POST, url, parameters: parameters)
            .responseJSON {(req, res, json) in
                if (json.isFailure) {
                    print("Error: \(json.error)")
                }
                else {
                    // we know we can force case since it isn't a failure
                    let json = JSON(json.value!)
                    
                    // call closure for what is past in (kind of like an anonymous function)
                    completion(item: json, error: nil)
                }
        }
    }
}