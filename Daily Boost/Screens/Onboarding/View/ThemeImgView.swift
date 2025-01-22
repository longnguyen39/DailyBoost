//
//  BackBtnView.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/4/24.
//

import SwiftUI

struct ThemeImgView: View {
    
    var imgName: String = "wall1s"
    
    var body: some View {
        Image(imgName)
            .resizable()
            .frame(width: UIScreen.width, height: 360)
            .scaledToFill()
            .ignoresSafeArea()
    }
}

#Preview {
    ThemeImgView()
}
