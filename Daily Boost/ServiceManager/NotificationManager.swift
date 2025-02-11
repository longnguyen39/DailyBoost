//
//  NotificationManager.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/8/25.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func requestAuthorization(completion: @escaping(Bool) -> Void) {
        let opt: UNAuthorizationOptions = [.alert, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: opt) { (granted, error) in
            if let e = error?.localizedDescription {
                print("DEBUG_Noti: err notification \(e)")
            } else {
                if granted {
                    print("DEBUG_Noti: notification granted!")
                    completion(true)
                } else {
                    print("DEBUG_Noti: notification denied!")
                    completion(false)
                }
            }
        }
    }
    
    func scheduleNoti(hour: Int, min: Int, catePArr: [String]) async {
        let quote = await ANewQ(catePArr: catePArr)
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Boost"
        content.body = "\(quote.script)" //\n for skip line
        content.userInfo = ["quotePath": "\(quote.title)/\(quote.category)#\(quote.orderNo)"]
        content.sound = .default
        
        var dateComp = DateComponents()
        dateComp.hour = hour
        dateComp.minute = min
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)//repeat daily
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("DEBUG_Noti: error setting noti request")
        }
    }
    
    func clearAllPendingNoti() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    
//MARK: --------------------------------------------------
    
    private func ANewQ(catePArr: [String]) async -> Quote {
        let randPath = catePArr.randomElement()!
        return await ServiceFetch.shared.fetchARandQuote(title: randPath.getTitle(), cate: randPath.getCate())
    }
    
}

