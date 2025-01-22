//
//  Date+Ext.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/18/25.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    //only used to get month string
    func getMonthStr(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> String {
        
        let monthInt = calendar.component(component, from: self)
        if monthInt == 1 {
            return "Jan"
        } else if monthInt == 2 {
            return "Feb"
        } else if monthInt == 3 {
            return "Mar"
        } else if monthInt == 4 {
            return "Apr"
        } else if monthInt == 5 {
            return "May"
        } else if monthInt == 6 {
            return "Jun"
        } else if monthInt == 7 {
            return "Jul"
        } else if monthInt == 8 {
            return "Aug"
        } else if monthInt == 9 {
            return "Sep"
        } else if monthInt == 10 {
            return "Oct"
        } else if monthInt == 11 {
            return "Nov"
        } else {
            return "Dec"
        }
    }
}
