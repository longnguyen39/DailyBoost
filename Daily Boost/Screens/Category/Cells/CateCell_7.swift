//
//  CateCell.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/25/24.
//

import SwiftUI

struct CateCell: View {
    
    let imgDim: CGFloat = 40
    let frameDim: CGFloat = 96
    
    var cateP: String
    @Binding var chosenCatePathArr: [String]
    @Binding var removeCateForYou: String //for color
    @Binding var addCateForYou: String //for color
    @Binding var showCateQuotes: Bool

    @State var mainColor: Color = .clear
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: frameDim + 24, height: frameDim)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(Color(.systemGray6))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(mainColor)
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
                        .foregroundStyle(isPicked() ? .black : .clear)
                        .padding(.all, 6)
                        .background(mainColor)
                        .clipShape(.circle)
                        .padding(.all, 6)
                }
                Spacer()
                Text(cateP.getCate()) //caption
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundStyle(.black)
                    .minimumScaleFactor(0.8)
                    .padding(.all, 8)
                    .frame(width: frameDim + 16)
                    .lineLimit(1)
            }
            
        }
        .onAppear {
            mainColor = returnBackgroundC()
        }
        .onTapGesture {
            pickCate()
            mainColor = returnBackgroundC()
        }
        .onChange(of: removeCateForYou) { _ in
            if removeCateForYou == cateP {
                mainColor = .clear
            }
        }
        .onChange(of: addCateForYou) { _ in
            if addCateForYou == cateP {
                mainColor = .yellow
            }
        }
        .onLongPressGesture(minimumDuration: 0.3) { //0.3s
            showCateQuotes.toggle()
            UserDefaults.standard.set(cateP, forKey: CATEPATH_CATEQUOTES)
        }
    }
    
    //MARK: - Functions
    
    private func returnBackgroundC() -> Color {
        return isPicked() ? .yellow : .clear
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
    CateCell(cateP: "Haha", chosenCatePathArr: .constant(Quote.purposeStrArr), removeCateForYou: .constant("ahha"), addCateForYou: .constant("haha"), showCateQuotes: .constant(false))
}
