//
//  User.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/18/24.
//

import Foundation

struct User: Codable { //cannot be encoded due to var cateArr
    var username: String
    var email: String
    var userID: String
    var dateSignedUp: Date
    var turnOnFiction: Bool
    
    var start: Int
    var end: Int
    var howMany: Int
    
    var cateArr: [String]
    var histArr: [String]
    
    static var mockData: User = User(username: "Batman", email: "batman@gmail.com", userID: "asd123", dateSignedUp: Date.now, turnOnFiction: false, start: 8, end: 10, howMany: 10, cateArr: Quote.purposeStrArr, histArr: [])
    
    static var emptyState: User = User(username: "", email: "", userID: "", dateSignedUp: Date.now, turnOnFiction: true, start: 8, end: 10, howMany: 10, cateArr: Quote.purposeStrArr, histArr: [])
    
}

struct currentUserDefaults {
    static let username = "username"
    static let userID = "userID"
}
