//
//  BackBtnView.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/4/24.
//

import SwiftUI

struct BackBtnView: View {
        
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Spacer()
        }
    }
}

#Preview {
    BackBtnView()
}
