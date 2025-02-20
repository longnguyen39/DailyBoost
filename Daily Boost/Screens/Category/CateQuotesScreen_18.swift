//
//  CateQuotesScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 9/12/24.
//

import SwiftUI

struct CateQuotesScreen: View {
    
    @Environment(\.colorScheme) var mode

    @AppStorage(UserDe.isDarkText) var isDarkText: Bool?
    var catePath: String?

    @Binding var user: User
    @Binding var showCateQuotes: Bool
    @Binding var chosenCatePathArr: [String]
    
    @State var displayQArr: [Quote] = []
    @State var histIntArr: [Int] = []
    @State var themeUIImage: UIImage = UIImage(named: "loading")!
        
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(displayQArr, id: \.self) { quote in
                            FeedCellScr(user: $user, quote: quote)
                                .frame(width: UIScreen.width, height: UIScreen.height)
                                .onAppear {
                                    Task {
                                        await cellAppear(quote: quote)
                                    }
                                } //cell appear after each swipe
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .onAppear {
                    Task {
                        await appendANewQ()
                        UserDefaults.standard.set(displayQArr[displayQArr.count-1].script, forKey: UserDe.quote_last)
                    }
                }
                .ignoresSafeArea()
            }
//            .navigationTitle(catePath?.getCate() ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .background { //this is the best background setup
                Image(uiImage: themeUIImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.width, height: UIScreen.height)
                    .ignoresSafeArea()
            }
            .onAppear {
                themeUIImage = loadThemeImgFromDisk(path: UserDe.Local_ThemeImg)
            }
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        showCateQuotes.toggle()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(mode == .light ?  .black : .white)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Button {
                        followFunc()
                    } label: {
                        if isFollowing() {
                            Text("Following")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundStyle(mode == .light ? .black : .white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(mode == .light ? .black : .white)
                                }
                        } else {
                            Text("Follow")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.c1, .c2, .c3, .c4, .c5]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
        }
        
    }
    
//MARK: - Functions
    
    private func cellAppear(quote: Quote) async {
        
        //update hist
        let arr = histIntArr.filter { $0 == quote.orderNo }
        if arr.isEmpty { //no dupl
            histIntArr.append(quote.orderNo)
            
            //check last quote b4 fetching
            let last = UserDefaults.standard.object(forKey: UserDe.quote_last) as? String ?? "nil"
            if quote.script == last {
                print("DEBUG_18: last quote")
                await appendANewQ()
                UserDefaults.standard.set(displayQArr[displayQArr.count-1].script, forKey: UserDe.quote_last)
            }
            
        } else { // when user swipe up (rewatch quotes)
            print("DEBUG_18: dupl, histIntArr no change")
        }
    }
    
    private func appendANewQ() async {
        guard let cateP = catePath else { return }
        let countNF = await  ServiceFetch.shared.fetchQuoteCount(title: cateP.getTitle(), cate: cateP.getCate(), isFiction: false)
        let countF = await ServiceFetch.shared.fetchQuoteCount(title: cateP.getTitle(), cate: cateP.getCate(), isFiction: true)
        
        if histIntArr.count < (countNF + countF) {
            var newQ = Quote.mockQuote
            var inHist = true
            
            while inHist {
                let randInt = await ServiceFetch.shared.generateRandInt(title: cateP.getTitle(), cate: cateP.getCate(), showOneCate: true, count_nf: countNF, count_f: countF) //avoid refetching countF and NF
                newQ = await ServiceFetch.shared.fetchAQuote(title: cateP.getTitle(), cate: cateP.getCate(), orderNo: randInt)
                inHist = existInHist(orderNo: randInt)
            }
            displayQArr.append(newQ)
            print("DEBUG_18: quoteArr count is \(displayQArr.count)")
        } else {
            print("DEBUG_18: Already fetch all quotes of \(displayQArr[0].category)")
        }
        
    }
    
    private func existInHist(orderNo: Int) -> Bool {
        let arr = histIntArr.filter { $0 == orderNo }
        if !arr.isEmpty {  //found in histArr
            print("DEBUG_18: found order \(orderNo) in histArr")
            return true
        } else {
            return false
        }
    }
    
    private func followFunc() {
        if let cateP = catePath {
            if isFollowing() {
                chosenCatePathArr = chosenCatePathArr.filter { $0 != cateP }
            } else {
                chosenCatePathArr.append(cateP)
            }
        } else {
            print("DEBUG_18: catePath not in UserD")
        }
    }
    
    private func isFollowing() -> Bool {
        for cateP in chosenCatePathArr {
            if cateP == catePath {
                return true //end func
            }
        }
        return false
    }
    
}

#Preview {
    CateQuotesScreen(user: .constant(User.mockData), showCateQuotes: .constant(false), chosenCatePathArr: .constant(["haha"]))
}
