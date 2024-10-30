//
//  CONSTANTS.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/27/24.
//

import Firebase

let DB_SOURCE_URL = "sourceURL"

struct DB_User {
    static let username = "username"
    static let email = "email"
    static let userID = "userID"
    static let dateSignedUp = "dateSignedUp"
    static let turnOnFiction = "turnOnFiction"
    static let start = "start"
    static let end = "end"
    static let howMany = "howMany"
    static let cateArr = "cateArr"
    static let histArr = "histArr"
}

let DB_CateTitle_count = "count"
let DB_CateTitle_fiction = "fiction"
let DB_CateTitle_nonf = "non-fiction"
let DB_CateTitle_authCount = "authors"
let DB_CateTitle_Ano = "anonymous"
let DB_CateTitle_time = "last-updated"




let CATEPATH_CATEQUOTES = "CateQuotes"

let DB_CATETITLE_COLL = "quotes"

let DB_USER_COLL = "users"

struct UserDe {
    static let first_time = "userDefault_firstTime" //can be ignored if we authorize only checking userID
    static let last_fetched_Q = "last_fetched_quote" //main screen, last-fetched quote before fetching new
    static let quote_last = "USER_D_QUOTE_LAST" //last fetched userD for showing all quotes in a cate
    static let did_welcome = "userDefault_Did_Welcome" //first-time user, or when no cate is chosen
    static let show_top_left = "show_top_left" //show top-left cate indication
}

let DB_QUOTE_HIST = 5 //max hist is 5 quotes
