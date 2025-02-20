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
    case procrastination
    case focus
    case work
    case college
    case success
    case wealth
    case money
    case hustling
    case discipline
    case failure
    
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
        case .procrastination:
            return "Procrastination"
        case .focus:
            return "Focus"
        case .work:
            return "Work"
        case .college:
            return "College"
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
        case .failure:
            return "Failure"
        }
    }
}
