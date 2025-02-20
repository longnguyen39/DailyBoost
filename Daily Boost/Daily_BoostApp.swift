
//
//  Daily_BoostApp.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/22/24.
//

import SwiftUI
import FirebaseCore

//Firebase + Notification
@Observable
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var notiQPath: String = ""

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // Happen when user tap on Noti
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        notiQPath = response.notification.request.content.userInfo["quotePath"] as! String
        print("DEBUG_AppDele: \(notiQPath)")
    }

}

@main
struct Daily_BoostApp: App {
    
    //Firebase + Notification
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            MainScreen()
//                .environment(delegate)
            UploadScreen()
        }
    }
}
