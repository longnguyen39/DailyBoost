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
                .frame(width: frameDim, height: frameDim)
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
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.medium)
                        .foregroundStyle(mainColor)
                        .padding(.all, 4)
                }
                Spacer()
                Text(cateP.getCate())
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundStyle(.black)
                    .padding(.all, 8)
                    .frame(width: 96)
                    .lineLimit(1)
            }
            
        }
        .onAppear {
            mainColor = returnBackgroundC()
        }
        .onTapGesture {
            pickCate(catePath: cateP)
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
    
    private func pickCate(catePath: String) {
        var didRemove = false
        for cateP in chosenCatePathArr {
            if cateP.getCate() == catePath.getCate() {
                chosenCatePathArr = chosenCatePathArr.filter() { $0.getCate() != catePath.getCate()
                } //remove picked cateP
                didRemove = true
                break
            }
        }
        if !didRemove {
            chosenCatePathArr.append(catePath)
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
