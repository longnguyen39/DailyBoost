//
//  MainScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 6/27/24.
//

import SwiftUI

struct MainScreen: View {
    
    @StateObject var firstTime = FirstTime()
    
    var body: some View {
        ZStack {
            if firstTime.isFirstTime {
                PurposeScreen()
            } else {
                HomeScreen()
            }
        }
        .environmentObject(firstTime)        
    }
}

#Preview {
    MainScreen()
}


