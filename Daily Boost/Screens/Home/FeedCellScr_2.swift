//
//  FeedCellScr.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//

import SwiftUI

struct FeedCellScr: View {
    
    var quote: Quote
    @Binding var showInfo: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text(quote.script)
                    .font(.system(size: 32))
                    .fontWeight(.regular)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text("-\(quote.author)")
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .foregroundStyle(.white)
                    .padding(.top, 4)
            }
            .offset(x: 0, y: -16) //off center a bit
            
            VStack {
                Spacer()
                
                HStack(spacing: 24) {
                    Button {
                        Task {
                            await uploadQuotes()
                        }
                    } label: {
                        ThreeImgBtnLbl(imgName: "square.and.arrow.up")
                    }
                    Button {
                        showInfo.toggle()
                    } label: {
                        ThreeImgBtnLbl(imgName: "info.circle")
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
        .sheet(isPresented: $showInfo) {
            InfoScreen()
        }
    }
    
    private func uploadQuotes() async {
        do {
            try await ServiceUpload.share.uploadCateTitle(quote: Quote.quoteArr[0])
            for quote in Quote.quoteArr {
                try await ServiceUpload.share.uploadOneQuote(quote: quote)
            }
            print("DEBUG_2: done uploading quote")
        } catch {
            print("DEBUG_2: err \(error)")
        }
    }
}

#Preview {
    FeedCellScr(quote: Quote.quoteArr[0], showInfo: .constant(false))
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
