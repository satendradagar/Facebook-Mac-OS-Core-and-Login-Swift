//
//  StringISOToDate.swift
//  AdvancedCalendar
//
//  Created by Satendra Dagar on 19/12/17.
//  Copyright © 2017 Satendra Singh. All rights reserved.
//

import Foundation

let dateFormatter = String.ISO08601DateFormatter()

extension String{
    
    func dateObject() -> Date? {
        
        let date = dateFormatter.date(from:self)
        return date
        
    }
    
   static func ISO08601DateFormatter() -> DateFormatter {
        let dateFmtter = DateFormatter()
        dateFmtter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFmtter
    }
}
