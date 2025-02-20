//
//  FeedCellScr.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//

import SwiftUI

struct FeedCellScr: View {
    
    @AppStorage(UserDe.isDarkText) var isDarkText: Bool?
    @AppStorage(UserDe.show_top_left) var showCateOnTop: Bool?
    
    @Binding var user: User
    var quote: Quote
    
    @State var showInfo: Bool = false
    @State var isLiked: Bool = false
    @State var opaLike: CGFloat = 0
    
    @State var showNoti: Bool = false
    
    var body: some View {
        ZStack {
            if showCateOnTop ?? true {
                CateTopView(cate: quote.category)
            }
            
            VStack(alignment: .center) {
                ZStack {
                    Text(quote.script.isEmpty ? "Loading..." : quote.script.replacingOccurrences(of: "USERNAME", with: user.username))
                        .font(.system(size: 28))
                        .fontWeight(.regular)
                        .foregroundStyle(isDarkText ?? false ? .black : .white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                        .font(.system(size: 80))
                        .scaleEffect(isLiked ? 1 : 0)
                        .opacity(opaLike)
                        .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: isLiked)
                }
                
                Text(quote.author.isEmpty ? "" : "-\(quote.author)")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .foregroundStyle(isDarkText ?? false ? .black : .white)
                    .padding(.top, 4)
                    .padding(.horizontal)
            }
            .offset(x: 0, y: -16) //up from center a bit
            .onTapGesture(count: 2) {
                Task {
                    await likeQuote()
                }
            }
            .onLongPressGesture(minimumDuration: 0.3) {
                showNoti.toggle()
//                NotificationManager.shared.clearAllPendingNoti()
            }
            
            VStack {
                Spacer()
                
                HStack(spacing: 24) {
                    
                    ShareLink(item: quoteToShare(), preview: SharePreview("Share Quote", image: quoteToShare())) {
                        ThreeImgBtnLbl(imgName: "square.and.arrow.up")
                            .foregroundStyle(isDarkText ?? false ? .black : .white)
                    }
                    
                    if !quote.author.isEmpty {
                        Button {
                            UserDefaults.standard.set(quote.author, forKey: AUTHOR)
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
        .sensoryFeedback(.impact(weight: .medium, intensity: 1), trigger: isLiked)
        .sheet(isPresented: $showInfo) {
            InfoScreen(showInfo: $showInfo)
        }
        .sheet(isPresented: $showNoti) {
            NotiReportScreen()
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
        
        if isLiked {
            await ServiceUpload.shared.unLikeQuote(userID: user.userID, quote: quote, likeQuote: nil)
            isLiked = false
        } else {
            await likeQuote()
        }
    }
    
    private func likeQuote() async {
        isLiked = true
        opaLike = 1
        await ServiceUpload.shared.uploadLikeQuote(userID: user.userID, quote: quote)
        
        try? await Task.sleep(nanoseconds: 0_900_000_000)//delay 9ms
        opaLike = 0
    }
    
    private func quoteToShare() -> Image {
        let uiImg = loadThemeImgFromDisk(path: UserDe.Local_ThemeImg)
        let shareV = shareQuoteImg(quote: quote, isDarkText: isDarkText ?? false, themeUIImage: uiImg)
        let renderer = ImageRenderer(content: shareV)
        
        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        } else {
            return Image("wall1")
        }
    }
    
}

#Preview {
    FeedCellScr(user: .constant(User.mockData), quote: Quote.mockQuote)
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
    var themeUIImage: UIImage
    
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
//            Image("wall1")
            Image(uiImage: themeUIImage)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.width, height: UIScreen.height)
                .ignoresSafeArea()
        }
    }
}
