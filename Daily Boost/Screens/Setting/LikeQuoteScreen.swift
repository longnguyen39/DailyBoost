//
//  LikeQuoteScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/20/25.
//

import SwiftUI

struct LikeQuoteScreen: View {
    
    @State var likeQuotes: [LikeQuote] = []
    @State var likeCount: Int = 0
    @State var likeQPicked: LikeQuote = .mockData
    
    @State var showLoading: Bool = false
    @State var showADelete: Bool = false
    
    @State var needPagi: Bool = false
    
    @Binding var user: User
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack { //only load when we scroll to it
                    if likeQuotes.isEmpty {
                        Text("You have not liked any quote yet.")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                            .padding(.top, 32)
                    } else {
                        CaptionView(context: "All liked quotes will be displayed here.")
                            .padding()
                        
                        ForEach(likeQuotes, id: \.self) { likeQuote in
                            LikeQuoteCell(quote: likeQuote, likeQPicked: $likeQPicked, showADelete: $showADelete)
                                .padding(.bottom, 8)
                                .transition(.scale)
                        }
                        
                        if needPagi {
                            Text(". . . . . .")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .padding(.all, 12)
                                .padding(.bottom)
                                .onAppear {
                                    Task {
                                        await paginateLikeQ()
                                    }
                                }
                        }
                        
                        Divider()
                            .padding()
                            .opacity(0.1)
                    }
                }
            }
            
            if showLoading {
                LoadingView()
            }
        }
        .navigationTitle("\(likeCount) Liked Quotes")
        .sensoryFeedback(.decrease, trigger: likeCount)
        .onAppear {
            Task {
                await fetchLikeQuotes()
            }
        }
        .onChange(of: likeQuotes) {
            needPagi = likeQuotes.count < likeCount
        }
        .confirmationDialog("Unlike quote?", isPresented: $showADelete, titleVisibility: .visible, actions: {
            Button("Cancel", role: .cancel, action: {})
            Button("Remove from Likes", role: .destructive, action: {
                Task {
                    await removeLikeQuote()
                    likeCount -= 1
                }
            })
        })
    }
    
    private func fetchLikeQuotes() async {
        showLoading = true
        
        likeCount = await ServiceFetch.shared.fetchLikeQCount(userID: user.userID)
        
        do {
            likeQuotes = try await ServiceFetch.shared.fetchLikeQuotes(userID: user.userID)
            
            try? await Task.sleep(nanoseconds: 0_100_000_000)
            showLoading = false
        } catch {
            print("DEBUG: Failed to fetch liked quotes: \(error.localizedDescription)")
            showLoading = false
        }
    }
    
    private func paginateLikeQ() async {
        print("DEBUG: paginating likeQ...")
        showLoading = true
        do {
            likeQuotes += try await ServiceFetch.shared.configPagiLikeQArr(userID: user.userID)
            
            try? await Task.sleep(nanoseconds: 0_100_000_000)
            showLoading = false
        } catch {
            print("DEBUG: Failed to paginate like quotes: \(error.localizedDescription)")
            showLoading = false
        }
    }
    
    private func removeLikeQuote() async {
        await ServiceUpload.shared.unLikeQuote(userID: user.userID, quote: nil, likeQuote: likeQPicked)
        for likeQ in likeQuotes {
            if likeQPicked.catePath == likeQ.catePath {
                withAnimation {
                    likeQuotes = likeQuotes.filter() { $0.catePath != likeQPicked.catePath
                    }
                }
            }
        }
    }
}

#Preview {
    LikeQuoteScreen(user: .constant(User.initState))
}

//------------------------------------------------------

struct LikeQuoteCell: View {
    
    @Environment(\.colorScheme) var mode
    @AppStorage(UserDe.isDarkText) var isDarkText: Bool?

    var quote: LikeQuote
    @Binding var likeQPicked: LikeQuote
    @Binding var showADelete: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(quote.script.isEmpty ? "Loading..." : quote.script)
                .font(.system(size: 16))
                .fontWeight(.regular)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                .padding(.top)
            
            HStack {
                Text(quote.author.isEmpty ? "" : "-\(quote.author)")
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    likeQPicked = quote
                    showADelete.toggle()
                } label: {
                    Image(systemName: "trash")
                        .imageScale(.medium)
                        .fontWeight(.medium)
                }
                
                ShareLink(item: quoteToShare(), preview: SharePreview("Share Quote", image: quoteToShare())) {
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.medium)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 4)
            .padding(.bottom)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .background(mode == .light ? Color.white : DARK_GRAY)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
        .onAppear {
//            //check for last likeQ
//            print("DEBUG_LikeQScr: likeQ \(quote.catePath)")
//            let lastPath = UserDefaults.standard.object(forKey: UserDe.last_fetched_likeQPath) as? String ?? "nil"
//            
//            if quote.catePath == lastPath {
//                print("DEBUG_LikeQScr: paginating likeQ...")
//                paginate = true
//            }
        }
    }
    
    private func quoteToShare() -> Image {
        let shareQ = Quote(orderNo: 0, script: quote.script, title: "", category: quote.catePath, isFictional: false, author: quote.author)
        let uiImg = loadThemeImgFromDisk(path: UserDe.Local_ThemeImg)
        let shareV = shareQuoteImg(quote: shareQ, isDarkText: isDarkText ?? false, themeUIImage: uiImg)
        let renderer = ImageRenderer(content: shareV)
        
        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        } else {
            return Image("wall1")
        }
    }
    
}
