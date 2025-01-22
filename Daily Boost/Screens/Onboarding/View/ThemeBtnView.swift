//
//  RecBtnView.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/13/25.
//

import SwiftUI

struct ThemeBtnView: View {
    
    var context: String
    var backC: Color = .yellow
    var foreC: Color = .black
    
    var body: some View {
        Text(context)
            .font(.headline)
            .foregroundStyle(foreC)
            .frame(width: UIScreen.width-32, height: 48)
            .background(backC)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
    }
}

#Preview {
    ThemeBtnView(context: "ahha")
}
