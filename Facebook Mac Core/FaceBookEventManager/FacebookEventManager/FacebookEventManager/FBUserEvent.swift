//
//  FBUserEvent.swift
//  AdvancedCalendar
//
//  Created by Satendra Dagar on 18/12/17.
//  Copyright © 2017 Satendra Singh. All rights reserved.
//

import Foundation
import EventKit

struct FBUserEvent {
    
    var title:String?
    var start:Date?
    var end:Date?
    var details:String?
    var eventID:String?
    var rsvp:String?
    var times :[[String:Any]]?
    
    
    init(event:Dictionary<String, Any>) {
        //       print(event)
        //["description": its a art fest ,lots of musical and dance performances will there up to 5th march .....u will have a great fun....., "start_time": 2012-03-01T14:00:00+0530, "name": sargam, "id": 826947067390405, "rsvp_status": unsure, "end_time": 2012-03-05T23:30:00+0530]
        title = event["name"] as? String
        details = event["description"] as? String
        rsvp = event["rsvp_status"] as? String
        eventID = event["id"] as? String
        if let startStr = event["start_time"] as? String {
            start = startStr.dateObject()
        }
        if let endStr = event["end_time"] as? String {
            end = endStr.dateObject()
        }
        if let eventTimes = event["event_times"] as? [[String:Any]] {
            times = eventTimes
        }
    }
    
    func descirption(){
        print("Title:\(title) Start:\(start) + End:\(end) + Details:\(details)")
    }
    func syncEventWithCalendar(calendar:EKCalendar) {
        
        if let eventTimings = times{
            for dict in eventTimings{
                let startTime = (dict["start_time"] as! String).dateObject()
                let endTime = (dict["end_time"] as! String).dateObject()
                let eventID = dict["id"] as! String
                let eventURL = "https://www.facebook.com/events/\(eventID)"
                calendar.syncEventWith(title: title, start: startTime, end: endTime, details: details, eventID: eventID, rsvp: rsvp, eventURL: eventURL)
            }
        }
        else{
            let eventURL = "https://www.facebook.com/events/\(String(describing: eventID))"
            calendar.syncEventWith(title: title, start: start , end: end, details: details, eventID: eventID, rsvp: rsvp, eventURL: eventURL)
        }
//        let eventStore = EKEventStore () //default event store
//        let type = EKEntityType.event;
//        let calendars : NSArray = eventStore.calendars(for: type) as NSArray
//        var _calendar : EKCalendar
//
//        // 2
//        let calendarTitle = "Home"
//        let predicate =  NSPredicate(format:"title matches %@", calendarTitle)
//        var filtered = calendars.filtered(using: predicate)
//
//        if (filtered.count > 0) {
//            _calendar = filtered[0] as! EKCalendar
//            print(_calendar.title)
//            if let id = eventID {//Get event id
////                let titlePredicate =  NSPredicate(format:"url.absoluteString matches %@",id)
//                if let startDat = start {
//                    var endDat = Calendar.current.date(byAdding: .year, value: 1, to: startDat)
//
//                    if let endDt = end {
//                        endDat = endDt
//                    }
//                    let pre = eventStore.predicateForEvents(withStart: startDat, end: endDat!, calendars: nil)
//                    let events = eventStore.events(matching: pre)
//
//                    var existingEvent: EKEvent?
//                    for evt in events{
//                        if ((evt.url?.absoluteString == "https://www.facebook.com/events/\(id)") || (evt.title == self.title && evt.notes == self.details)){//Check if matching, we just set the url
//                            existingEvent = evt
//                            break;
//                        }
//
//                    }
//                    if let oldEvent = existingEvent{
//                        oldEvent.title = title ?? "";
//                        oldEvent.notes = details
//                        oldEvent.url = URL.init(string: "https://www.facebook.com/events/\(id)")
//
//                        if let startDat = start {
//                            oldEvent.startDate = startDat
//                        }
//                        if let endDat = end {
//                            oldEvent.endDate = endDat
//                        }
//                    }
//                    else{ //Create a new event in the DB
//                        let newEvent = EKEvent.init(eventStore: eventStore)
//
//                        newEvent.title = title ?? "";
//                        newEvent.notes = details
//                        newEvent.url = URL.init(string: "https://www.facebook.com/events/\(id)")
//
//                        newEvent.calendar = _calendar
//                        if let startDat = start {
//                            newEvent.startDate = startDat
//                            if let endDat = end {
//                                newEvent.endDate = endDat
//                            }
//                            else{
//                                let endDat = start?.addingTimeInterval(24.0*60.0*60.0)//Assing it for full day
//                                newEvent.endDate = endDat!
//                            }
//                        }
//
//                        do {
//
//                            try eventStore.save(newEvent, span: .thisEvent, commit: true)
//                            /* delegate?.eventDidAdd()
//
//                             self.dismissViewControllerAnimated(true, completion: nil)*/
//                        } catch {
//                            let err = error as NSError
//                            //                let details = err.localizedDescription
//                            //                let alert = NSAlert(title: "Event could not save", message: details, preferredStyle: .Alert)
//                            NSApp.presentError(err)
//                            print("\((error as NSError).localizedDescription)")
//
//                        }
//
//                    }
//                }
//            }
//        }

    }
}


