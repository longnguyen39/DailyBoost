//
//  PreviewThemeScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 11/6/24.
//

import SwiftUI

struct PreviewThemeScreen: View {
    
    @Binding var showPreviewScreen: Bool
    @Binding var isDarkText: String
    var imgName: String
    
    @State var tintColor: Color = .white
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Someone’s sitting in the shade today because someone planted a tree a long time ago.")
                    .font(.system(size: 32))
                    .fontWeight(.regular)
                    .foregroundStyle(tintColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text("-Warren Buffet")
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .foregroundStyle(tintColor)
                    .padding(.top, 4)
            }
            .offset(x: 0, y: -16) //up from center a bit
            .onAppear {
                isDarkText = "false"
            }
            
            VStack {
                Spacer()
                
                Button {
                    if isDarkText == "false" {
                        isDarkText = "true"
                        tintColor = Color.black
                    } else {
                        isDarkText = "false"
                        tintColor = Color.white
                    }
                } label: {
                    ContBtnView(context: "Dark Text", isStandard: true)
                }
                
                Button {
                    showPreviewScreen.toggle()
                } label: {
                    ContBtnView(context: "Dismiss", isStandard: false)
                }
            }
        }
        .background {
            Image(imgName)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.width, height: UIScreen.height)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    PreviewThemeScreen(showPreviewScreen: .constant(true), isDarkText: .constant(""), imgName: "wall1")
}
