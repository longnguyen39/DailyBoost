//
//  Cate5_Relation.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/25/24.
//

import Foundation

enum Cate5_Relation: CaseIterable {
    case trust
    case honesty
    case forgive
    case introvert
    case extrovert
    case love
    case friendship
    case family
    case parenthood
    case loyalty
    case beSingle
    case fakePeople
    case teamwork
    
    var name: String {
        switch self {
        case .trust:
            return "Trust"
        case .honesty:
            return "Honesty"
        case .forgive:
            return "Forgiveness"
        case .introvert:
            return "Introvert"
        case .extrovert:
            return "Extrovert"
        case .love:
            return "Love"
        case .friendship:
            return "Friendship"
        case .family:
            return "Family"
        case .parenthood:
            return "Parenthood"
        case .loyalty:
            return "Loyalty"
        case .beSingle:
            return "Being single"
        case .fakePeople:
            return "Fake people"
        case .teamwork:
            return "Teamwork"
        }
    }
}
