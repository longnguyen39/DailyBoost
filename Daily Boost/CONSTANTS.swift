//
//  CONSTANTS.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/27/24.
//

import Firebase

let DB_SOURCE_URL = "sourceURL"

struct DB_User {
    static let coll = "users"
    
    static let like_coll = "Liked Quotes"
    static let like_path = "CatePath"

    static let username = "username"
    static let email = "email"
    static let userID = "userID"
    static let dateSignedUp = "dateSignedUp"
    static let fictionOption = "fictionOption"
    static let start = "start"
    static let end = "end"
    static let howMany = "howMany"
    static let cateArr = "cateArr"
    static let histArr = "histArr"
    static let plan = "plan"
}

struct DB_Theme {
    static let coll = "themeImages"
    static let img = "Images"
    
    static let fileName = "fileName"
    static let title = "title"
    static let darkText = "isDarkText"
}


let CATEPATH_CATEQUOTES = "CateQuotes"

let DB_CATETITLE_COLL = "quotes"


struct UserDe {
    static let fictionOption = "fictionOption"
    
    static let first_time = "userDefault_firstTime" //can be ignored if we authorize only checking userID
    static let did_welcome = "userDefault_Did_Welcome" //first-time user, or when no cate is chosen

    static let last_fetched_Q = "last_fetched_quote" //main screen, last-fetched quote before fetching new
    static let quote_last = "USER_D_QUOTE_LAST" //last fetched userD for showing all quotes in a cate
    
    //LikeQuoteScr, last-fetched quote before fetching new
    static let last_fetched_likeQPath = "last_fetched_likeQPath"
    static let last_fetched_likeQTime = "last_fetched_likeQTime"

    
    static let show_top_left = "show_top_left" //show top-left cate indication
    static let themeNotFetch = "themeNotFetch"
    
    static let Local_ThemeImg = "Local_ThemeImg"
    static let isDarkText = "isDarkText"
    static let themeFileName = "themeFileName"

}

let DB_QUOTE_HIST = 10 //max hist is 10 quotes
let resetPassNote = "We just send a Reset-Password link to your email. Please check your inbox."
