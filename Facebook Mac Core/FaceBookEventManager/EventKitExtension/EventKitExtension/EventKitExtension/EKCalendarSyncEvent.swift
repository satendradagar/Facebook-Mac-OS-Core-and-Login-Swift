//
//  EKCalendarSyncEvent.swift
//  AdvancedCalendar
//
//  Created by Satendra Dagar on 20/04/18.
//  Copyright © 2018 Satendra Singh. All rights reserved.
//

import Foundation
import EventKit

let calendarName = "Google Cal"

public extension EKCalendar{
    
    func syncEventWith(title:String?, start:Date?,end:Date?,details:String?,eventID:String?,rsvp:String?, eventURL:String) {
        let eventStore = EKEventStore () //default event store
        
        print(self.title)
        if let startDat = start {
            var endDat = Calendar.current.date(byAdding: .year, value: 1, to: startDat)
            
            if let endDt = end {
                endDat = endDt
            }
            let pre = eventStore.predicateForEvents(withStart: startDat, end: endDat!, calendars: nil)
            let events = eventStore.events(matching: pre)
            
            var existingEvent: EKEvent?
            for evt in events{
                if ((evt.url?.absoluteString == eventURL) || (evt.title == title && evt.notes == details)){//Check if matching, we just set the url
                    existingEvent = evt
                    break;
                }
                
            }
            if let oldEvent = existingEvent{
                oldEvent.title = title ?? "";
                oldEvent.notes = details
                oldEvent.url = URL.init(string: eventURL)
                
                if let startDat = start {
                    oldEvent.startDate = startDat
                }
                if let endDat = end {
                    oldEvent.endDate = endDat
                }
            }
            else{ //Create a new event in the DB
                let newEvent = EKEvent.init(eventStore: eventStore)
                
                newEvent.title = title ?? "";
                newEvent.notes = details
                newEvent.url = URL.init(string: eventURL)
                
                newEvent.calendar = self
                if let startDat = start {
                    newEvent.startDate = startDat
                    if let endDat = end {
                        newEvent.endDate = endDat
                    }
                    else{
                        let endDat = start?.addingTimeInterval(24.0*60.0*60.0)//Assing it for full day
                        newEvent.endDate = endDat!
                    }
                }
                
                do {
                    
                    try eventStore.save(newEvent, span: .thisEvent, commit: true)
                    
                } catch {
                    let err = error as NSError
                    DispatchQueue.main.async {
                        NSApp.presentError(err)
                        print("\((error as NSError).localizedDescription)")
                    }
                }
            }
        }
    }
    
    static func calendarWithTitle(calendarName:String) -> EKCalendar {
        let eventStore = EKEventStore () //default event store
        let type = EKEntityType.event;
        let calendars : NSArray = eventStore.calendars(for: type) as NSArray
        var _calendar : EKCalendar
        
        // 2
        let calendarTitle = calendarName
        let predicate =  NSPredicate(format:"title matches %@", calendarTitle)
        var filtered = calendars.filtered(using: predicate)
        if (filtered.count == 0) {//Create a new calendar
            _calendar = EKCalendar.init(for: .event, eventStore: eventStore)
            _calendar.title = calendarName
            _calendar.attachLocalSourceType()
            do {
                
                try eventStore.saveCalendar(_calendar, commit: true)
                
            } catch {
                let err = error as NSError
                //                let details = err.localizedDescription
                //                let alert = NSAlert(title: "Event could not save", message: details, preferredStyle: .Alert)
                DispatchQueue.main.async {
                    NSApp.presentError(err)
                    print("\((error as NSError).localizedDescription)")
                }
                
            }
            //            _calendar.calendarIdentifier = fbCalendarIdentifier
        }
        else {//(filtered.count > 0)
            _calendar = filtered[0] as! EKCalendar
        }
        print(_calendar.title)
        return _calendar;
    }
}


extension EKCalendar{
    
    func attachLocalSourceType()  {
        // Iterate over all sources in the event store and look for the local source
        let eventStore = EKEventStore() //default event store
        
        var theSource:EKSource?;
        for source in eventStore.sources {
            if (source.sourceType == EKSourceType.local) {
                theSource = source;
                break;
            }
        }
        
        if let localSource = theSource {
            self.source = localSource;
        }
    }
    
    func deleteCalendar(calendarName:String) {
        
        let eventStore = EKEventStore () //default event store
        let type = EKEntityType.event;
        let calendars : NSArray = eventStore.calendars(for: type) as NSArray
        var _calendar : EKCalendar
        
        // 2
        let calendarTitle = calendarName
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

}

