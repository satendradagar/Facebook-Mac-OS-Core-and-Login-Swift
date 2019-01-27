//
//  FBEventStroreManger.swift
//  AdvancedCalendar
//
//  Created by Satendra Dagar on 18/12/17.
//  Copyright © 2017 Satendra Singh. All rights reserved.
//

import Foundation
import EventKitExtension
import EventKit

let fbCalendarName = "FB Lilius"
let fbCalendarIdentifier = "com.fb.Lilius"

public class FBEventStroreManger: NSObject {
    var timer: Timer?
    private var fbEvents = [FBUserEvent]()
    public static let sharedStore = FBEventStroreManger()
//    lazy var sharedStore: FBEventStroreManger = {
//        return FBEventStroreManger()
//    }()

   public func setupRefreshFacebookEventsTimer(){
        if nil != timer{//avoid any existing timer
            self.tearDownRefreshTimer()
        }
         timer = Timer.scheduledTimer(timeInterval: 1800, target: self, selector: #selector(self.refreshEvents), userInfo: nil, repeats: true)

    }
    
   public func tearDownRefreshTimer()  {
        timer?.invalidate()
        timer = nil
    }
    
    @objc public func refreshEvents()  {
        FacebookEventManager.requestEventUpdate(sender: nil)
    }
    
    func updateEvent(event: FBUserEvent)  {
        
    }

   public func removeFacebookCalendar() {
        self.tearDownRefreshTimer()
        let eventStore = EKEventStore () //default event store
        let type = EKEntityType.event;
        let calendars : NSArray = eventStore.calendars(for: type) as NSArray
        var _calendar : EKCalendar
        
        // 2
        let calendarTitle = fbCalendarName
        let predicate =  NSPredicate(format:"title matches %@", calendarTitle)
        var filtered = calendars.filtered(using: predicate)
        
        if (filtered.count > 0)
        {
            _calendar = filtered[0] as! EKCalendar
            do {
                
                try eventStore.removeCalendar(_calendar, commit: true)
                
            } catch {
                let err = error as NSError
                //                let details = err.localizedDescription
                //                let alert = NSAlert(title: "Event could not save", message: details, preferredStyle: .Alert)
                DispatchQueue.main.async {
                    NSApp.presentError(err)
                    print("\((error as NSError).localizedDescription)")
                }
                
            }
        }
    }
    
    func updateEvents(eventsDict: [[String:Any]])  {
        let calendar = EKCalendar.calendarWithTitle(calendarName:fbCalendarName)
        for dict in eventsDict {
            let uEvent = FBUserEvent.init(event: dict)
            print(uEvent.descirption())
            uEvent.syncEventWithCalendar(calendar: calendar)
        }
    }

    func allEvents() ->[FBUserEvent] {
    
        return fbEvents;
    }

}

