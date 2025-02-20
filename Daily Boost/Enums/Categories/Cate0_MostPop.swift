//
//  Cate0_MostPop.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/12/25.
//

import Foundation

enum Cate0_MostPop: CaseIterable {
    case affirmations
    case procrastination
    case positivity
    case harsh
    case growth
    case motivation
    case overFear
    case beYourself
    case loneliness
    case failure

    var name: String {
        switch self {
        case .affirmations:
            return "Affirmations"
        case .procrastination:
            return "Procrastination"
        case .positivity:
            return "Positivity"
        case .harsh:
            return "Harsh truths"
        case .growth:
            return "Growth"
        case .motivation:
            return "Motivation"
        case .overFear:
            return "Fear"
        case .beYourself:
            return "Be Yourself"
        case .loneliness:
            return "Loneliness"
        case .failure:
            return "Failure"
        }
    }
    
    var title: String {
        switch self {
        case .affirmations:
            return CateTitle.one.title
        case .procrastination:
            return CateTitle.four.title //prod
        case .positivity:
            return CateTitle.one.title
        case .harsh:
            return CateTitle.seven.title //calm
        case .growth:
            return CateTitle.one.title //love self
        case .motivation:
            return CateTitle.one.title //love self
        case .overFear:
            return CateTitle.two.title //hard times
        case .beYourself:
            return CateTitle.one.title //love self
        case .loneliness:
            return CateTitle.two.title //hard times
        case .failure:
            return CateTitle.four.title //productivity
        }
    }
    
}
