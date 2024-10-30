//
//  Cate7_LoveSelf.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/25/24.
//

import Foundation

enum Cate1_LoveSelf: CaseIterable {
    case motivation
    case badassMotiv
    case mindfulness
    case selfLove
    case confidence
    case ego
    case beYourself
    case positiveThought
    case newStart
    case moveOn
    case growth
    case gratitude
    case selfDoubt
    
    var name: String {
        switch self {
        case .motivation:
            return "Motivation"
        case .badassMotiv:
            return "Badass"
        case .mindfulness:
            return "Mindfulness"
        case .selfLove:
            return "Self-love"
        case .confidence:
            return "Confidence"
        case .ego:
            return "Ego"
        case .beYourself:
            return "Be Yourself"
        case .positiveThought:
            return "Positivity"
        case .newStart:
            return "New start"
        case .moveOn:
            return "Moving on"
        case .growth:
            return "Growth"
        case .gratitude:
            return "Gratitude"
        case .selfDoubt:
            return "Self-doubt"
        }
    }
}
