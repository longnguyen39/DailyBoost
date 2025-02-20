//
//  WidgetScreen_9.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/8/24.
//

import SwiftUI

struct WidgetScreen: View {
        
    @Binding var user: User
    @Binding var pickedCateArr: [String]
    
    var body: some View {
        VStack {
            ThemeImgView()
            
            Text("Let's add a widget to your screen")
                .font(.system(size: 20))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, -40)
                .padding(.bottom, 12)
            
            WidgetStack(spacing: 0)
            
            Spacer()
            
            NavigationLink {
                EmailScreen(user: $user, pickedCateArr: $pickedCateArr)
            } label: {
                ContBtnView(context: "Got it!")
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
}

#Preview {
    WidgetScreen(user: .constant(User.initState), pickedCateArr: .constant(Quote.purposeStrArr))
}

//-------------------------------------------------

struct WidgetStack: View {
    
    var spacing: CGFloat
    var lineH: CGFloat = 104
    
    var body: some View {
        VStack(spacing: spacing) {
            HStack {
                ZStack {
                    Rectangle()
                        .frame(width: 64, height: 64)
                        .foregroundStyle(.clear)
                    
                    Image(systemName: "hand.tap")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .scaledToFit()
                }
                
                Text("Hold down your finger anywhere on your screen until the apps jiggle.")
                    .font(.footnote)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                Spacer()
            }.frame(height: lineH)
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .frame(width: 64, height: 32)
                        .foregroundStyle(.gray.opacity(0.4))
                    
                    Image(systemName: "plus")
                        .imageScale(.medium)
                        .fontWeight(.medium)
                }
                
                Text("Tap the + button at the top left corner, you will be present with some widget options.")
                    .font(.footnote)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                Spacer()
            }.frame(height: lineH)
            
            HStack {
                Image("logo")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text("Pick Daily Boost icon from the list. Then you can customize your widget.")
                    .font(.footnote)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                Spacer()
            }.frame(height: lineH)
        }
        .padding(.horizontal)
    }
}

