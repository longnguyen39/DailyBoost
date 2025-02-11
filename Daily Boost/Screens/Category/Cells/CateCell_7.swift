//
//  CateCell.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/25/24.
//

import SwiftUI

struct CateCell: View {
    
    @Environment(\.colorScheme) var mode
    let imgDim: CGFloat = 32
    let frameDim: CGFloat = 88
    
    var cateP: String
    @Binding var chosenCatePathArr: [String]
    @Binding var showCateQuotes: Bool
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: frameDim + 32, height: frameDim)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(mode == .light ? LIGHT_GRAY : DARK_GRAY)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1.5)
                        .foregroundStyle(isPicked() ? .color3 : .clear)
                }
            
            VStack {
                Image(cateP.getCate())
                    .resizable()
                    .scaledToFit()
                    .frame(width: imgDim, height: imgDim)
                    .padding(.top)
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 8, height: 8)
                        .fontWeight(.bold)
                        .foregroundStyle(isPicked() ? .white : .clear)
                        .padding(.all, 6)
                        .background(isPicked() ? .color3 : .clear)
                        .clipShape(.circle)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 6)
                }
                
                Spacer()
                
                Text(cateP.getCate()) //caption
                    .font(.caption)
                    .fontWeight(.regular)
                    .minimumScaleFactor(0.8)
                    .padding(.all, 8)
                    .frame(width: frameDim + 16)
                    .lineLimit(1)
            }
            
        }
        .sensoryFeedback(.increase, trigger: chosenCatePathArr)
        .onTapGesture {
            withAnimation {
                pickCate()
            }
        }
        .onLongPressGesture(minimumDuration: 0.3) { //0.3s
            showCateQuotes.toggle()
            UserDefaults.standard.set(cateP, forKey: CATEPATH_CATEQUOTES)
        }
        
    }
    
//MARK: - Functions
    
    private func returnBackgroundC() -> Color {
        return isPicked() ? .color3 : .clear
    }
    
    private func pickCate() {
        var didRemove = false
        if chosenCatePathArr.count > 1 {
            //de-select picked cateP
            for catePh in chosenCatePathArr {
                if catePh.getCate() == cateP.getCate() {
                    chosenCatePathArr = chosenCatePathArr.filter() { $0.getCate() != cateP.getCate()
                    }
                    didRemove = true
                    break
                }
            }
        }
        if !didRemove {
            //cannot add the same cateP to arr
            let noAppend = chosenCatePathArr.count == 1 &&  chosenCatePathArr[0] == cateP
            if noAppend {
                print("DEBUG_7: no append")
            } else {
                chosenCatePathArr.insert(cateP, at: 0) //append to front of arr
            }
        }
    }
    
    private func isPicked() -> Bool {
        for catePath in chosenCatePathArr {
            if cateP.getCate() == catePath.getCate() {
                return true
            }
        }
        return false
    }
}

#Preview {
    CateCell(cateP: "Haha", chosenCatePathArr: .constant(Quote.purposeStrArr), showCateQuotes: .constant(false))
}
