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
                    print("\nDEBUG_Noti: notification granted!")
                    completion(true)
                } else {
                    print("\nDEBUG_Noti: notification denied!")
                    completion(false)
                }
            }
        }
    }
    
    func setANotiWithQ(timeSec: Int, quote: Quote, username: String) {
        
        let script = quote.script.replacingOccurrences(of: "USERNAME", with: username)
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Boost"
        content.body = script
        content.userInfo = ["quotePath": "\(quote.title)/\(quote.category)#\(quote.orderNo)"]
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(timeSec), repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func setReminderNoti(timeSec: Int) {
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Boost"
        content.body = "Hello, time to read some Daily Boost Motivation!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(timeSec), repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func clearAllPendingNoti() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func clearAllDeliveredNoti() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    
//MARK: --------------------------------------------------
    
    
    
}

