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
    var cateP: String
    @Binding var showCateQuotes: Bool
    
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
                    .padding(.top, 20)
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
                    .minimumScaleFactor(0.8)
                    .padding(.all, 8)
                    .padding(.bottom, 4)
                    .frame(width: frameDim + 16)
                    .lineLimit(1)
            }
            
        }
        .onTapGesture {
            //gotta have this to make the HScrollV dragable
        }
        .onLongPressGesture(minimumDuration: 0.3) {
            showCateQuotes.toggle()
            UserDefaults.standard.set(cateP, forKey: CATEPATH_CATEQUOTES)
        }
    }
    
    //MARK: - Function
    
    private func removeCate() {
        chosenCatePathArr = chosenCatePathArr.filter { $0 != cateP }
    }
    
}

#Preview {
    CateCellForYou(chosenCatePathArr: .constant(Quote.purposeStrArr), cateP: "", showCateQuotes: .constant(false))
}
