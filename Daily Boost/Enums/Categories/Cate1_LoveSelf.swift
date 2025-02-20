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
    case affirmations
    case selfLove
    case confidence
    case ego
    case beYourself
    case positivity
    case newStart
    case moveOn
    case growth
    case gratitude
    case selfDoubt
    case women
    case men
    
    var name: String {
        switch self {
        case .motivation:
            return "Motivation"
        case .badassMotiv:
            return "Badass quotes"
        case .mindfulness:
            return "Mindfulness"
        case .affirmations:
            return "Affirmations"
        case .selfLove:
            return "Self-love"
        case .confidence:
            return "Confidence"
        case .ego:
            return "Ego"
        case .beYourself:
            return "Be Yourself"
        case .positivity:
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
        case .women:
            return "Women empowerment"
        case .men:
            return "Be a man"
        }
    }
}
