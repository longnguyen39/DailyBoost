//
//  CateCellForYou.swift
//  Daily Boost
//
//  Created by Long Nguyen on 9/12/24.
//

import SwiftUI

struct CateCellForYou: View {
    
    let imgDim: CGFloat = 40
    let frameDim: CGFloat = 96
    
    @Binding var removeCateForYou: String
    @Binding var chosenCatePathArr: [String]
    var cateP: String
    @Binding var showCateQuotes: Bool
    
    @State var mainColor: Color = .clear
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: frameDim + 24, height: frameDim)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(Color(.systemGray6))
            
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
                            .foregroundStyle(.black)
                            .padding(.trailing, -4)
                            .onTapGesture {
                                removeCate()
                            }
                    }
                }
                Spacer()
                Text(cateP.getCate())
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundStyle(.black)
                    .padding(.all, 8)
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
        removeCateForYou = cateP
    }
    
}

#Preview {
    CateCellForYou(removeCateForYou: .constant("haha"), chosenCatePathArr: .constant(Quote.purposeStrArr), cateP: "", showCateQuotes: .constant(false))
}
