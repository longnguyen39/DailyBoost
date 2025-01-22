//
//  FeedCellScr.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//

import SwiftUI

struct FeedCellScr: View {
    
    @AppStorage(UserDe.isDarkText) var isDarkText: Bool?
    @AppStorage(currentUserDefaults.userID) var userID: String?
    
    var quote: Quote
    @Binding var showInfo: Bool
    @Binding var showCateOnTop: Bool
    
    @State var isLiked: Bool = false
    
    var body: some View {
        ZStack {
            if showCateOnTop {
                CateTopView(cate: quote.category)
            }
            
            VStack(alignment: .center) {
                Text(quote.script.isEmpty ? "Loading..." : quote.script)
                    .font(.system(size: 32))
                    .fontWeight(.regular)
                    .foregroundStyle(isDarkText ?? false ? .black : .white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text(quote.author.isEmpty ? "" : "-\(quote.author)")
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .foregroundStyle(isDarkText ?? false ? .black : .white)
                    .padding(.top, 4)
                    .padding(.horizontal)
            }
            .offset(x: 0, y: -16) //up from center a bit
            
            VStack {
                Spacer()
                
                HStack(spacing: 24) {
                    
                    ShareLink(item: quoteToShare(), preview: SharePreview("Share Quote", image: quoteToShare())) {
                        ThreeImgBtnLbl(imgName: "square.and.arrow.up")
                            .foregroundStyle(isDarkText ?? false ? .black : .white)
                    }
                    
                    if !quote.author.isEmpty {
                        Button {
                            showInfo.toggle()
                        } label: {
                            ThreeImgBtnLbl(imgName: "info.circle")
                                .foregroundStyle(isDarkText ?? false ? .black : .white)
                        }
                    }
                    
                    Button {
                        Task {
                            await hitLikeQuote()
                        }
                    } label: {
                        ThreeImgBtnLbl(imgName: isLiked ? "heart.fill" : "heart")
                            .foregroundStyle(configLikeBtn())
                    }
                }
                .foregroundStyle(.white)
                .padding(.bottom, 160)
            }
        }
    }
    
//MARK: - Function
    
    private func configLikeBtn() -> Color {
        if isLiked {
            return .red
        } else {
            return isDarkText ?? false ? .black : .white
        }
    }
    
    private func hitLikeQuote() async {
        let uid = userID ?? ""
        
        if isLiked {
            await ServiceUpload.shared.unLikeQuote(userID: uid, quote: quote, likeQuote: nil)
            isLiked = false
        } else {
            isLiked = true
            await ServiceUpload.shared.uploadLikeQuote(userID: uid, quote: quote)
        }
    }
    
    private func quoteToShare() -> Image {
        let shareV = shareQuoteImg(quote: quote, isDarkText: isDarkText ?? false)
        let renderer = ImageRenderer(content: shareV)
        
        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        } else {
            return Image("wall1")
        }
    }
    
}

#Preview {
    FeedCellScr(quote: Quote.quoteFirst, showInfo: .constant(false), showCateOnTop: .constant(true))
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
    
    @AppStorage(UserDe.isDarkText) var isDarkText: Bool?
    var cate: String
    
    var body: some View {
        VStack {
            HStack {
                Text(cate)
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                    .foregroundStyle(isDarkText ?? false ? .black : .white)
                    .padding()
                    .padding(.top, 44)
                Spacer()
            }
            Spacer()
        }
    }
}

struct shareQuoteImg: View {
    
    var quote: Quote
    var isDarkText: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .center) {
                Text(quote.script)
                    .font(.system(size: 32))
                    .fontWeight(.regular)
                    .foregroundStyle(isDarkText ? .black : .white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text(quote.author.isEmpty ? "" : "-\(quote.author)")
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .foregroundStyle(isDarkText ? .black : .white)
                    .padding(.top, 4)
                    .padding(.horizontal)
            }
            .offset(x: 0, y: -16)
            
            Spacer()
        }
        .frame(width: UIScreen.width, height: UIScreen.height)
        .background {
            Image("wall1")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.width, height: UIScreen.height)
                .ignoresSafeArea()
        }
    }
}
