//
//  ContinueBtn.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/4/24.
//

import SwiftUI

struct ContBtnView: View {
    
    var context: String = "Continue"
    var isStandard: Bool = true
    
    var body: some View {
        Text(context)
            .font(.headline)
            .fontWeight(.regular)
            .foregroundStyle(isStandard ? .white : .red)
            .frame(width: UIScreen.width-72, height: 56)
            .background(isStandard ? .color2 : .clear)
            .clipShape(.capsule)
            .padding()
    }
}

#Preview {
    ContBtnView()
}
