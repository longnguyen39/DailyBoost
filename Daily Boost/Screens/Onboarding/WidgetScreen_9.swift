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
                .font(.system(size: 24))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
                .padding(.horizontal)
                .padding(.top, -40)
                .padding(.bottom, 24)
            
            HStack {
                Image("wall1")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text("Hold down your finger anywhere on your screen until the apps jiggle.")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                    .padding()
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
            
            HStack {
                plusTopBtn()
                
                Text("Tap the + button at the top left corner, pick Daily Boost widget and add it to your screen.")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                    .padding()
                
                Spacer()
            }
            .padding(.horizontal)
            
            
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

struct plusTopBtn: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 72, height: 28)
                .foregroundStyle(.gray.opacity(0.4))
            
            Image(systemName: "plus")
                .imageScale(.medium)
                .fontWeight(.medium)
                .foregroundStyle(.black)
        }
    }
}
