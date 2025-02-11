//
//  CateRow.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/6/25.
//

import SwiftUI

struct CateRow: View {
    
    @Environment(\.colorScheme) var mode
    let imgDim: CGFloat = 24
    
    var cateP: String
    @Binding var chosenCatePathArr: [String]

    @State var followColor: Color = .clear
    
    var body: some View {
        HStack {
            Image(cateP.getCate())
                .resizable()
                .scaledToFit()
                .frame(width: imgDim, height: imgDim)
            
            Text(cateP.getCate()) //caption
                .font(.subheadline)
                .fontWeight(.regular)
                .minimumScaleFactor(0.8)
                .padding(.all, 8)
                .lineLimit(1)
            
            Spacer()
            
            Button {
                followCate()
            } label: {
                if isFollowing() {
                    FollowBtnLbl(context: "Following")
                        .foregroundStyle(mode == .light ? .black : .white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                                .foregroundStyle(mode == .light ? .black : .white)
                        }
                } else {
                    FollowBtnLbl(context: "Follow")
                        .foregroundStyle(.white)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.c1, .c2, .c3, .c4, .c5]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .sensoryFeedback(.decrease, trigger: chosenCatePathArr)
        }
    }
    
//MARK: - Function
    
    private func followCate() {
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
                print("DEBUG_CateRow: already following")
            } else {
                chosenCatePathArr.insert(cateP, at: 0) //append to front of arr
            }
        }
    }
    
    private func isFollowing() -> Bool {
        for catePath in chosenCatePathArr {
            if cateP.getCate() == catePath.getCate() {
                return true
            }
        }
        return false
    }
    
}

#Preview {
    CateRow(cateP: "Haha", chosenCatePathArr: .constant(Quote.purposeStrArr))
}

//MARK: -----------------------------------------------

struct FollowBtnLbl: View {
    
    @Environment(\.colorScheme) var mode
    var context: String
    
    var body: some View {
        Text(context)
            .font(.caption)
            .fontWeight(.regular)
            .padding(.horizontal)
            .padding(.vertical, 8)
    }
}
