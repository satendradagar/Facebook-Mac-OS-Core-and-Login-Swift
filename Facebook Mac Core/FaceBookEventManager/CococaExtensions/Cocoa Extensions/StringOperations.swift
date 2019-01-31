//
//  StringOperations.swift
//  AdvancedCalendar
//
//  Created by Satendra Dagar on 25/02/18.
//  Copyright © 2018 Satendra Singh. All rights reserved.
//

import Foundation

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
