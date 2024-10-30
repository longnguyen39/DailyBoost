//
//  GoalScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 6/27/24.
//

import SwiftUI

struct PurposeScreen: View {
    
    var body: some View {
        VStack {
            BackBtnView()
            
            Text("Purpurse")
            
            Spacer()
            
            NavigationLink {
                TimeScreen()
            } label: {
                ContBtnView()
            }

        }
    }
}

#Preview {
    PurposeScreen()
}
