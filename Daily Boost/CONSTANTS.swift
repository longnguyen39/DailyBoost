//
//  CONSTANTS.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/27/24.
//

import Firebase
import SwiftUI

let DB_SOURCE_URL = "sourceURL"
let AUTHOR = "AUTHOR" //stupid Xcode bug that makes me do this
let DARK_GRAY = Color.gray.opacity(0.2)
let LIGHT_GRAY = Color(.systemGray6)


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


let DB_CATETITLE_COLL = "quotes"


struct UserDe {
    static let fictionOption = "fictionOption"
    
    static let lastDayOpened = "lastDayOpened"
    static let lastSecTilMidnight = "lastSecTilMidnight"
    static let currentStreak = "currentStreak"
    static let justLogin = "justLogin"
    
    static let first_time = "userDefault_firstTime" //can be ignored if we authorize only checking userID

    static let last_fetched_Q = "last_fetched_quote" //homeScreen
    static let quote_last = "USER_D_QUOTE_LAST" //CateQuoteScr_18
    
    //LikeQuoteScr, last-fetched quote before fetching new
    static let last_fetched_likeQPath = "last_fetched_likeQPath"
    static let last_fetched_likeQTime = "last_fetched_likeQTime"

    
    static let show_top_left = "show_top_left" //show top-left cate indication
    static let themeNotFetch = "themeNotFetch"
    
    static let Local_ThemeImg = "Local_ThemeImg"
    static let isDarkText = "isDarkText"
    static let themeFileName = "themeFileName"
    
}

let DB_QUOTE_HIST = 30 //max hist is 30 quotes
let TimeDecree = 30*60 //plus or minus seconds
let resetPassNote = "We just send a Reset-Password link to your email. Please check your inbox."
