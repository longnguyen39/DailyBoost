//
//  NotiReport.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/16/25.
//

import SwiftUI

struct NotiReportScreen: View {
    
    @State var notifications: [String] = ["yo", "ha"]
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(notifications, id: \.self) { noti in
                    Text("Hello \(noti)")
                        .padding()
                }
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().getPendingNotificationRequests { noti in
                
                let c = noti.count
                notifications.append("Pending Count is \(c)")
                
            }
        }
    }
}

#Preview {
    NotiReportScreen()
}
