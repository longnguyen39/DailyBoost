//
//  User.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/18/24.
//

import Foundation

struct User: Decodable { //cannot be encoded due to var cateArr
    var username: String
    var email: String
    var userID: String
    var dateSignedUp: Date
    var fictionOption: String //mostly for report purpose
    var plan: String
    
    var start: Int
    var end: Int
    var howMany: Int
    
    var cateArr: [String]
    var histArr: [String]
    
    static var mockData: User = User(username: "Batman", email: "batman@gmail.com", userID: "asd123", dateSignedUp: Date.now, fictionOption: FictionOption.both.name, plan: "", start: 8*3600, end: 10*3600, howMany: 12, cateArr: Quote.purposeStrArr, histArr: [])
    
    static var initState: User = User(username: "username", email: "", userID: "", dateSignedUp: Date.now, fictionOption: FictionOption.both.name, plan: "", start: 8*3600, end: 22*3600, howMany: 12, cateArr: [], histArr: [])
    
//    static var initState: User = User(username: "username", email: "", userID: "", dateSignedUp: Date.now, fictionOption: FictionOption.both.name, plan: "", start: 1200, end: 1320, howMany: 20, cateArr: Quote.purposeStrArr, histArr: [])
    
}

struct currentUserDefaults {
    static let username = "username"
    static let userID = "userID"
}
