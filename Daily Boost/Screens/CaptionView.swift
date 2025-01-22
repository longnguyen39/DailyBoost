//
//  CaptionView.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/20/25.
//

import SwiftUI

struct CaptionView: View {
    
    var context: String
    
    var body: some View {
        HStack {
            Text("*\(context)")
                .font(.caption)
                .fontWeight(.regular)
                .foregroundStyle(.gray)
            Spacer()
        }
        .padding(.horizontal)
    }
}
