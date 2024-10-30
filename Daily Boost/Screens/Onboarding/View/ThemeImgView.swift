//
//  BackBtnView.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/4/24.
//

import SwiftUI

struct ThemeImgView: View {
        
    var body: some View {
        Image("wall1")
            .resizable()
            .frame(width: UIScreen.width, height: 360)
            .scaledToFit()
            .ignoresSafeArea()
    }
}

#Preview {
    ThemeImgView()
}
