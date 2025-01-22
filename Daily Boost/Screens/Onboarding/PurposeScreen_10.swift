//
//  GoalScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 6/27/24.
//

import SwiftUI

struct PurposeScreen: View {
    
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
                
                Text("What areas of life would you like to improve?")
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(.horizontal)
                    .padding(.top, -40)
                
                Text("Please choose at least 4 areas.")
                    .font(.system(size: 16))
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
                        .opacity(canContinue() ? 1.0 : 0.4)
                }
                .disabled(!canContinue())
                
                NavigationLink {
                    LoginScreen()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?  - ")
                            .fontWeight(.regular)
                            .foregroundStyle(.black)
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
    
    let imgDim: CGFloat = 24
    var purpose: String
    @Binding var user: User
    @Binding var pickedCateArr: [String]
    
    @State var backgroundC: Color = .gray.opacity(0.2) //gotta use this method since LazyHGrid does NOT change backgroundC of any UI hidden in the far end of scrollV
    
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
                .foregroundStyle(.black)
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
        .onTapGesture {
            pickPurpose(purpose: purpose)
            backgroundC = returnBackgroundC()
        }
    }
    
    private func returnBackgroundC() -> Color {
        return isPicked() ? .yellow : .gray.opacity(0.2)
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
