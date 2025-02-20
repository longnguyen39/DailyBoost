//
//  GoalScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 6/27/24.
//

import SwiftUI

struct PurposeScreen: View {
    
    @Environment(\.colorScheme) var mode
    @Environment(AppDelegate.self) var appData
    
    let rows: [GridItem] = [GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())] // 3 rows, space btw rows
    let purposeArr: [String] = Quote.purposeStrArr
    @State var user: User = User.initState
    @State var pickedCateArr: [String] = []
        
    var body: some View {
        NavigationView {
            VStack {
                ThemeImgView()
                
                Text("What areas would you like to improve?")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, -40)
                
                Text("Please choose at least 4 areas.")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                    .padding()
                    .padding(.top, -20)
                                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: rows, spacing: 0) {
                        ForEach(purposeArr, id: \.self) { purpose in
                            PurposeCell(purpose: purpose, user: $user, pickedCateArr: $pickedCateArr)
                            //move TapGesture to PurposeCell since LazyHGrid+ScrollView do NOT support background change
                        }
                    }
                }
                .frame(height: 168)
                .padding(.top, 8)
                
                Spacer()
                
                NavigationLink {
                    TimeScreen(user: $user, pickedCateArr: $pickedCateArr)
                } label: {
                    ContBtnView()
                        .opacity(canContinue() ? 1.0 : 0.6)
                }
                .disabled(!canContinue())
                
                NavigationLink {
                    LoginScreen()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?  - ")
                            .fontWeight(.regular)
                            .foregroundStyle(mode == .light ? .black : .white)
                        Text(" Login")
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                    .font(.subheadline)
                }
                .padding(.bottom)
                .padding(.top, 8)
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                appData.notiQPath = ""
            }
        }
    }
    
    private func canContinue() -> Bool {
        return pickedCateArr.count >= 4
    }
}

#Preview {
    PurposeScreen()
}

struct PurposeCell: View {
    
    @Environment(\.colorScheme) var mode
    let imgDim: CGFloat = 24
    
    var purpose: String
    @Binding var user: User
    @Binding var pickedCateArr: [String]
    
    @State var foregroundC: Color = .black
    @State var backgroundC: Color = DARK_GRAY //gotta use this method since LazyHGrid does NOT change backgroundC of any UI hidden in the far end of scrollV
    
    var body: some View {
        HStack {
            Image(purpose.getCate())
                .resizable()
                .scaledToFit()
                .frame(width: imgDim, height: imgDim)
            
            Text(purpose.getCate())
                .font(.system(size: 16))
                .fontWeight(.regular)
                .lineLimit(1)
                .foregroundStyle(foregroundC)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 12)
        .frame(width: 144, height: 48)
        .background(backgroundC)
        .clipShape(RoundedRectangle(cornerRadius: 12))
//        .overlay {
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(lineWidth: 4)
//                .foregroundStyle(isPicked() ? .black : .clear)
//        }
        .padding(.leading, 12)
        .onChange(of: mode) {
            backgroundC = mode == .light ? LIGHT_GRAY : DARK_GRAY
            foregroundC = mode == .light ? .black : .white
        }
        .onAppear {
            backgroundC = returnBackgroundC()
            foregroundC = returnForegroundC()
        }
        .onTapGesture {
            pickPurpose(purpose: purpose)
            backgroundC = returnBackgroundC()
            foregroundC = returnForegroundC()
        }
    }
    
    private func returnBackgroundC() -> Color {
        if mode == .light {
            return isPicked() ? .color2 : LIGHT_GRAY
        } else {
            return isPicked() ? .color2 : DARK_GRAY
        }
    }
    
    private func returnForegroundC() -> Color {
        if mode == .light {
            return isPicked() ? .white : .black
        } else {
            return .white
        }
    }
    
    private func pickPurpose(purpose: String) {
        var didChange = false
        
        for quoteP in pickedCateArr {
            if quoteP.getCate() == purpose.getCate() {
                pickedCateArr = pickedCateArr.filter() { $0.getCate() != purpose.getCate() } //remove picked quoteP
                didChange = true
                break
            }
        }
        if !didChange {
            pickedCateArr.append(purpose)
        }
    }
    
    private func isPicked() -> Bool {
        for quotePath in pickedCateArr {
            if purpose.getCate() == quotePath.getCate() {
                return true
            }
        }
        return false
    }
}
