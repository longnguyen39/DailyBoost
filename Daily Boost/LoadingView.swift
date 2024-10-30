//
//  LoadingView.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/20/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.black).opacity(0.5)
                .ignoresSafeArea()
            
            ProgressView {
                Text("Loading")
                    .font(.subheadline)
                    .fontWeight(.regular)
            }
            .foregroundStyle(.white)
            .tint(.white) //for spinner
        }
        
    }
}

#Preview {
    LoadingView()
}
