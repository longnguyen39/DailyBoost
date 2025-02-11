//
//  WidgetScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/2/25.
//

import SwiftUI

struct WidgetInstructScreen: View {
    
    var body: some View {
        VStack {
            CaptionView(context: "Let's add a widget to your screen!")
                .padding()
                .padding(.bottom, 8)
            
            WidgetStack(spacing: 24)
            
            Spacer()
            
        }
        .navigationTitle("Widget")
    }
}

#Preview {
    WidgetInstructScreen()
}
