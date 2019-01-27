//
//  FacebookEventManager.swift
//  AdvancedCalendar
//
//  Created by Satendra Dagar on 18/12/17.
//  Copyright © 2017 Satendra Singh. All rights reserved.
//

import Foundation
import Cocoa
import Facebook_Mac_Core

public class FacebookEventManager: NSObject {
    
   public static func refreshAccessToken() {
        AccessToken.refreshCurrentToken { (token, error) in
            print("refreshed token:\(String(describing: token)), \nError:\(String(describing: error))")
            print("Expiry:\(String(describing: token?.expirationDate))")
            if nil != error{
                
            }
        }
    }
    
   public static func refreshEventsWithCompletion(parameters: [String : Any]) {
        let req = GraphRequest(graphPath: "me/events", parameters:parameters, accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!)
        req.start({ (connection, result) in
            switch result {
            case .failed(let error):
                print(error)
                
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
//                    print(responseDictionary)
                    
                    if let eventData = responseDictionary["data"] as? [[String:Any]]{
                        
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                            FBEventStroreManger.sharedStore.updateEvents(eventsDict: eventData)
                        }
                    
                    }
                    
                    if let paging = responseDictionary["paging"] as? [String:Any] {
                        if let cursors = paging["cursors"] as? [String:Any] {
                            //                            self.refreshEventsWithCompletion(parameters:cursors)
                            
                            if let after = cursors["after"] as? String {
                                
                                print("\n\n\n\n\ntrying to load next page")
                                
                                self.refreshEventsWithCompletion(parameters:["after":after])
                            }
                            
                        }
                    } else {
                        print("Can't read next!!!")
                    }
                    
                }
            }
        })
    }
    
   public static func requestEventUpdate(sender:Any?){//"publish_stream",
        //["fields":"email,first_name,last_name,gender,picture"]
        /*
         FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
         initWithGraphPath:@"/me/events"
         parameters:nil
         HTTPMethod:@"GET"];
         [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         // Insert your code here
         }];
         */
        refreshEventsWithCompletion(parameters: [:])
        return
    }
    
}
