//
//  CateQuotesScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 9/12/24.
//

import SwiftUI

struct CateQuotesScreen: View {
    @AppStorage(CATEPATH_CATEQUOTES) var catePath: String?
//    @AppStorage(UserDe.isDarkText) var isDarkText: Bool?
        
    @Binding var showCateQuotesScr: Bool
    @Binding var chosenCatePathArr: [String]
    
    @State var quoteArr: [Quote] = []
    @State var histIntArr: [Int] = []
    @State var themeUIImage: UIImage = UIImage(named: "loading")!
        
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(quoteArr, id: \.self) { quote in
                        FeedCellScr(quote: quote, showInfo: .constant(false), showCateOnTop: .constant(false))
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
                    UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: UserDe.quote_last)
                }
            }
            .ignoresSafeArea()
            
            
            VStack {
                
                HStack {
                    Text(catePath?.getCate() ?? "Error")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(.gray)
                        .clipShape(.capsule)
                    
                    Spacer()
                    
                    Button {
                        showCateQuotesScr.toggle()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                            .background(.black)
                            .clipShape(.circle)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    followFunc()
                } label: {
                    HStack {
                        Text(isFollowing() ? "Following" : " Follow ")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                        
                        if isFollowing() {
                            Image(systemName: "checkmark.circle.fill")
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.yellow)
                                .background(.black)
                                .clipShape(.circle)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(isFollowing() ? .gray : .yellow)
                    .clipShape(.capsule)
                    .padding(.bottom)
                }
            }
        }
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
                UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: UserDe.quote_last)
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
            quoteArr.append(newQ)
            print("DEBUG_18: quoteArr count is \(quoteArr.count)")
        } else {
            print("DEBUG_18: Already fetch all quotes of \(quoteArr[0].category)")
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
    CateQuotesScreen(showCateQuotesScr: .constant(false), chosenCatePathArr: .constant(["haha"]))
}
