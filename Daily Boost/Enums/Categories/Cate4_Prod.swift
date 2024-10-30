//
//  Cate4_Prod.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/25/24.
//

import Foundation

enum Cate4_Prod: CaseIterable {
    case habit
    case routine
    case entrepreneur
    case productivity
    case focus
    case work
    case college
    case success
    case wealth
    case money
    case hustling
    case discipline
    
    var name: String {
        switch self {
        case .habit:
            return "Habit"
        case .routine:
            return "Routine"
        case .entrepreneur:
            return "Entrepreneur"
        case .productivity:
            return "Productivity"
        case .focus:
            return "Focus"
        case .work:
            return "Work"
        case .college:
            return "Habit"
        case .success:
            return "Success"
        case .wealth:
            return "Wealth"
        case .money:
            return "Money"
        case .hustling:
            return "Hustling"
        case .discipline:
            return "Discipline"
        }
    }
    
//    var imgStr: String {
//        switch self {
//        case .habit:
//            <#code#>
//        case .routine:
//            <#code#>
//        case .entrepreneur:
//            <#code#>
//        case .productivity:
//            <#code#>
//        case .focus:
//            <#code#>
//        case .work:
//            <#code#>
//        case .college:
//            <#code#>
//        case .success:
//            <#code#>
//        case .wealth:
//            <#code#>
//        case .money:
//            <#code#>
//        case .hustling:
//            <#code#>
//        case .discipline:
//            <#code#>
//        }
//    }
}
