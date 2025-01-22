//
//  MainScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 6/27/24.
//

import SwiftUI

//DELETE all userD
//let defaultDict = UserDefaults.standard.dictionaryRepresentation()
//defaultDict.keys.forEach { key in
//    UserDefaults.standard.removeObject(forKey: key)
//}

struct MainScreen: View {
    
    //we only need either var firstTime or userID in UserDe, we include firstTime to know how to deal with Environment var
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
        .onAppear {
            if let fTime = UserDefaults.standard.object(forKey: UserDe.first_time) {
                firstTime.isFirstTime = fTime as! Bool
            }
        }
    }
}

#Preview {
    MainScreen()
}


