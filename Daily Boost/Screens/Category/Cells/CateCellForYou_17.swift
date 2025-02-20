//
//  CateCellForYou.swift
//  Daily Boost
//
//  Created by Long Nguyen on 9/12/24.
//

import SwiftUI

struct CateCellForYou: View {
    
    @Environment(\.colorScheme) var mode
    let imgDim: CGFloat = 32
    let frameDim: CGFloat = 88
    
    @Binding var chosenCatePathArr: [String]
    @Binding var user: User
    var cateP: String
    
    @State var showCateQuotes: Bool = false
    @State var mainColor: Color = .clear
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: frameDim + 32, height: frameDim)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(mode == .light ? LIGHT_GRAY : DARK_GRAY)
            
            VStack {
                Image(cateP.getCate())
                    .resizable()
                    .scaledToFit()
                    .frame(width: imgDim, height: imgDim)
                    .padding(.top, 18)
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                    if chosenCatePathArr.count > 1 {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.medium)
                            .foregroundStyle(mode == .light ?  .black : .white)
                            .padding(.trailing, -4)
                            .onTapGesture {
                                withAnimation {
                                    removeCate()
                                }
                            }
                    }
                }
                Spacer()
                Text(cateP.getCate())
                    .font(.caption)
                    .fontWeight(.regular)
                    .minimumScaleFactor(0.9)
                    .padding(.all, 8)
                    .padding(.bottom, 4)
                    .frame(width: frameDim + 16)
                    .lineLimit(1)
            }
            
        }
        .sensoryFeedback(.selection, trigger: showCateQuotes)
        .sensoryFeedback(.decrease, trigger: chosenCatePathArr)
        .onTapGesture { //gotta have this to make the HScrollV dragable
            showCateQuotes.toggle()
        }
//        .onLongPressGesture(minimumDuration: 0.3) {
//            showCateQuotes.toggle()
//        }
        .fullScreenCover(isPresented: $showCateQuotes) {
            CateQuotesScreen(catePath: cateP, user: $user, showCateQuotes: $showCateQuotes, chosenCatePathArr: $chosenCatePathArr)
        }
    }
    
    //MARK: - Function
    
    private func removeCate() {
        chosenCatePathArr = chosenCatePathArr.filter { $0 != cateP }
    }
    
}

#Preview {
    CateCellForYou(chosenCatePathArr: .constant(Quote.purposeStrArr), user: .constant(User.mockData), cateP: "")
}
