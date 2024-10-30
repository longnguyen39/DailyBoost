//
//  ContinueBtn.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/4/24.
//

import SwiftUI

struct ContBtnView: View {
    
    var context: String = "Continue"
    
    var body: some View {
        Text(context)
            .font(.headline)
            .fontWeight(.medium)
            .foregroundStyle(.black)
            .frame(width: UIScreen.width-80, height: 60)
            .background(.yellow)
            .clipShape(.capsule)
            .padding()
    }
}

#Preview {
    ContBtnView()
}
