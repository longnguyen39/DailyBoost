//
//  UtilityFUnc.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/23/24.
//

import UIKit

func findCharPos(needle: Character, str: String) -> Int {
    if let idx = str.firstIndex(of: needle) {
        let pos = str.distance(from: str.startIndex, to: idx)
        return pos
    } else {
        return 0
    }
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" //length = 62
    return String((0..<length).map{ _ in letters.randomElement()! })
}


func loadThemeImgFromDisk(path: String) -> UIImage {
    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
    
    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
    
    if let dirPath = paths.first {
        let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(path)
        let image = UIImage(contentsOfFile: imageUrl.path)
        return image ?? UIImage(named: "wall1")!
    }
    return UIImage(named: "wall1")!
}

func getCurrentS() -> Int {
    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: Date.now)
    let nowH = components.hour ?? 0
    let nowM = components.minute ?? 0
    let nowS = components.second ?? 0
    let currentS = nowH * 3600 + nowM * 60 + nowS
    print("DEBUG_uniFunc: currentS \(currentS), at \(nowH):\(nowM):\(nowS)")
    return currentS
}

//MARK: - Notification

func setAllNoti(user: User) async {
    NotificationManager.shared.clearAllPendingNoti()
    var quote = Quote.mockQuote
    let cateArr = user.cateArr
    
    print("DEBUG_uniFunc: after clearing, now set noti...")
    
    let currentS = getCurrentS()
    let gap = user.end - user.start //only set (end > start)
    
    //set Noti for current day
    let gapNowToEnd = user.end - currentS
    
    if gapNowToEnd >= gap { //set noti b4 start time
        for i in 0..<user.howMany {
            quote = await ANewQ(catePArr: cateArr)

            if i == 0 {
                print("DEBUG_uniFunc: plus \(gapNowToEnd - gap)")
                NotificationManager.shared.setANotiWithQ(timeSec: (gapNowToEnd - gap), quote: quote, username: user.username)
            } else if i == user.howMany - 1 {
                print("DEBUG_uniFunc: plus \(gapNowToEnd)")
                NotificationManager.shared.setANotiWithQ(timeSec: gapNowToEnd, quote: quote, username: user.username)
            } else {
                let randSec = Int.random(in:(gapNowToEnd - gap + 300)...(gapNowToEnd-300))
                NotificationManager.shared.setANotiWithQ(timeSec: randSec, quote: quote, username: user.username)
                print("DEBUG_uniFunc: plus \(randSec)")
            }
        }
        
    } else if gapNowToEnd > 0 { //set noti during time frame
        
        let leftOver = Float(user.howMany) / (Float(gap) / Float(gapNowToEnd))
        let leftOverNotiToday: Int = Int(leftOver.rounded())
        
        if leftOverNotiToday == 0 {
            NotificationManager.shared.setANotiWithQ(timeSec: gapNowToEnd, quote: quote, username: user.username) //make one for the end time
        }
        
        for i in 0..<leftOverNotiToday {
            quote = await ANewQ(catePArr: cateArr)
            
            if i == leftOverNotiToday-1 {
                NotificationManager.shared.setANotiWithQ(timeSec: gapNowToEnd, quote: quote, username: user.username)
                print("DEBUG_uniFunc: plus \(gapNowToEnd)")
            } else {
                let randSec = Int.random(in: 0...(gapNowToEnd-300))
                NotificationManager.shared.setANotiWithQ(timeSec: randSec, quote: quote, username: user.username)
                print("DEBUG_uniFunc: plus \(randSec)")
            }
        }
    }
    
    
    //set noti for next days (max noti setup is 64)
    let dayAvailable = (64 - user.howMany) / user.howMany
    
    for day in 0..<dayAvailable {
        let gapb4Start = (86400 - currentS) + user.start +  (86400 * day)
        print("\nDEBUG_uniFunc: next \(day+1) day ---------------------------")
        for i in 0..<user.howMany {
            quote = await ANewQ(catePArr: cateArr)
            
            if i == 0 {
                NotificationManager.shared.setReminderNoti(timeSec: gapb4Start-60)
                NotificationManager.shared.setANotiWithQ(timeSec: gapb4Start, quote: quote, username: user.username)
                print("DEBUG_uniFunc: plus \(gapb4Start)")
            } else if i == user.howMany - 1 {
                NotificationManager.shared.setANotiWithQ(timeSec: gapb4Start+gap, quote: quote, username: user.username)
                print("DEBUG_uniFunc: plus \(gapb4Start+gap)")
                if day == dayAvailable-1 {
                    print("DEBUG_uniFunc: done set all noti")
                }
            } else {
                let randSec = Int.random(in: (gapb4Start+300)...(gapb4Start+gap-300))
                NotificationManager.shared.setANotiWithQ(timeSec: randSec, quote: quote, username: user.username)
                print("DEBUG_uniFunc: plus \(randSec)")
            }
        }
    }

}


func setNotiTmr(user: User) async {
    
    var quote = Quote.mockQuote
    let cateArr = user.cateArr
    
    print("DEBUG_uniFunc: after clearing, now set noti...")
    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: Date.now)
    let nowH = components.hour ?? 0
    let nowM = components.minute ?? 0
    let nowS = components.second ?? 0
    
    let gap = user.end - user.start //only set (end > start)
    let currentS = nowH * 3600 + nowM * 60 + nowS
    
    //set noti for tmr
    let gapb4Start = (86400 - currentS) + user.start
    print("\nDEBUG_uniFunc: setting noti for next day ---------------------------")
    for i in 0..<user.howMany {
        quote = await ANewQ(catePArr: cateArr)
        
        if i == 0 {
            NotificationManager.shared.setANotiWithQ(timeSec: gapb4Start, quote: quote, username: user.username)
            print("DEBUG_uniFunc: plus \(gapb4Start)")
        } else if i == user.howMany - 1 {
            NotificationManager.shared.setANotiWithQ(timeSec: gapb4Start+gap, quote: quote, username: user.username)
            print("DEBUG_uniFunc: plus \(gapb4Start+gap)")
            print("DEBUG_uniFunc: done set noti for tmr")
        } else {
            let randSec = Int.random(in: (gapb4Start+300)...(gapb4Start+gap-300))
            NotificationManager.shared.setANotiWithQ(timeSec: randSec, quote: quote, username: user.username)
            print("DEBUG_uniFunc: plus \(randSec)")
        }
    }
}

func ANewQ(catePArr: [String]) async -> Quote {
    let randPath = catePArr.randomElement()!
    return await ServiceFetch.shared.fetchARandQuote(title: randPath.getTitle(), cate: randPath.getCate())
}


//func refillNoti(user: User, countLeft: Int) async {
//    
//    print("\nDEBUG_uniFunc: pending noti count \(countLeft)")
//    var quote = Quote.mockQuote
//    if countLeft == 0 {
//        await setAllNoti(user: user)
//        return
//    }
//    if (64 - countLeft) < user.howMany {
//        print("DEBUG_uniFunc: all noti set, no need refill")
//        return
//    }
//    
//    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: Date.now)
//    let nowH = components.hour ?? 0
//    let nowM = components.minute ?? 0
//    let nowS = components.second ?? 0
//    
//    let gap = user.end - user.start //always > 0
//    
//    let currentS = nowH * 3600 + nowM * 60 + nowS
//    let gapNowToEnd = user.end - currentS
//    print("DEBUG_uniFunc: refill at \(nowH):\(nowM):\(nowS)")
//    
//    var dayAnchor = countLeft / user.howMany
//    let daysAdvance = (64 - countLeft) / user.howMany
//    
//    if currentS < user.start { //b4 start time
//        dayAnchor -= 1
//    }
//    
//    let startTimeNewDay = (86400 - currentS) + (dayAnchor * 86400)
//    
//    for day in 0..<daysAdvance {
//        let startTime = startTimeNewDay + (86400 * day) + user.start
//        
//        for i in 0..<user.howMany {
//            quote = await ANewQ(catePArr: user.cateArr)
//
//            if i == 0 {
//                NotificationManager.shared.setANotiWithQ(
//                    timeSec: startTime,
//                    quote: quote
//                )
//                print("DEBUG_uniFunc: plus \(startTime)")
//            } else if i == user.howMany - 1 {
//                NotificationManager.shared.setANotiWithQ(
//                    timeSec: startTime + gap,
//                    quote: quote
//                )
//                print("DEBUG_uniFunc: plus \(startTime+gap)")
//                if day == daysAdvance-1 {
//                    print("DEBUG_uniFunc: done refill all noti")
//                }
//            } else {
//                let randSec = Int.random(in: (startTime+300)...(startTime+gap-300))
//                NotificationManager.shared.setANotiWithQ(timeSec: randSec, quote: quote)
//                print("DEBUG_uniFunc: plus \(randSec)")
//            }
//        }
//    }
//}

func streakTextMessage() -> String {
    let currentStreak = UserDefaults.standard.object(forKey: UserDe.currentStreak) as? Int ?? 1
    if currentStreak == 1 {
        return "You did a great job reading Daily Boost quotes. Let's go for 3 days."
    } else if currentStreak < 3 {
        return "You are on your way to a 3-day commitment."
    } else if currentStreak < 7 {
        return "Yes! Let's go for 1-week commitment."
    } else if currentStreak < 14 {
        return "You are on your way to a 2-week commitment."
    } else if currentStreak < 30 {
        return "Hurray! You are on your way to a 30-day commitment."
    } else if currentStreak < 60 {
        return "Way to go! You are on your way to a 60-day commitment."
    } else if currentStreak < 80 {
        return "Two month's gone. Let's go for 80 days."
    } else if currentStreak < 100 {
        return "You are achiving greatness. Let's go for a 100-day commitment."
    } else if currentStreak < 120 {
        return "Big milestone. Now you are on your way to a 120-day commitment"
    } else if currentStreak < 150 {
        return "Let's go for 150 days."
    } else if currentStreak < 200 {
        return "Awesome! On the way to 200 days."
    } else if currentStreak < 250 {
        return "Massive success! Let's crack 250 days!"
    } else if currentStreak < 300 {
        return "You are crushing it. Way to go on 300 days."
    } else if currentStreak < 350 {
        return "Hey hey! You are onto something great..."
    } else if currentStreak < 365 {
        return "You are so close!!! Let's make it a full year."
    } else if currentStreak == 365 {
        return "You are a legend. Let's go for next year!"
    } else {
        return "I commit to the next day"
    }
}
