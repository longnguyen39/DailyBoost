//
//  FeedCellScr.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//

import SwiftUI

struct FeedCellScr: View {
    
    var quote: Quote
    var isMainScreen: Bool //separate scr 1 and scr 18
    @Binding var showInfo: Bool
    @Binding var showCateOnTop: Bool
    
    var body: some View {
        ZStack {
            if showCateOnTop {
                CateTopView(cate: quote.category)
            }
            
            VStack(alignment: .center) {
                Text(quote.script.isEmpty ? "Loading..." : quote.script)
                    .font(.system(size: 32))
                    .fontWeight(.regular)
                    .foregroundStyle(isMainScreen ? .white : .black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text(quote.author.isEmpty ? "" : "-\(quote.author)")
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .foregroundStyle(isMainScreen ? .white : .black)
                    .padding(.top, 4)
            }
            .offset(x: 0, y: -16) //up from center a bit
            
            if isMainScreen {
                VStack {
                    Spacer()
                    
                    HStack(spacing: 24) {
                        Button {
                            
                        } label: {
                            ThreeImgBtnLbl(imgName: "square.and.arrow.up")
                        }
                        
                        if !quote.author.isEmpty {
                            Button {
                                showInfo.toggle()
                            } label: {
                                ThreeImgBtnLbl(imgName: "info.circle")
                            }
                        }
                        
                        Button {
                            
                        } label: {
                            ThreeImgBtnLbl(imgName: "heart")
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(.bottom, 160)
                }

            }
        }
    }
    
}

#Preview {
    FeedCellScr(quote: Quote.quoteFirst, isMainScreen: true, showInfo: .constant(false), showCateOnTop: .constant(true))
}

//MARK: -----------------------------------------------

struct ThreeImgBtnLbl: View {
    
    var btnDim: CGFloat = 32
    var imgName: String
    
    var body: some View {
        if imgName == "square.and.arrow.up" {
            Image(systemName: imgName)
                .resizable()
                .scaledToFit()
                .frame(width: btnDim+2, height: btnDim+2)
                .padding(.bottom, 2)
        } else {
            Image(systemName: imgName)
                .resizable()
                .scaledToFit()
                .frame(width: btnDim, height: btnDim)
        }
        
    }
}

struct CateTopView: View {
    
    var cate: String
    
    var body: some View {
        VStack {
            HStack {
                Text(cate)
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.top, 44)
                Spacer()
            }
            Spacer()
        }
    }
}
