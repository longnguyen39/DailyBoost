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
    @Binding var removeCateForYou: String
    @Binding var addCateForYou: String
    
    @State var quoteArr: [Quote] = []
    @State var duplArr: [Int] = []
    @State var themeUIImage: UIImage = UIImage(named: "loading")!
        
    var body: some View {
        ZStack {
            if #available(iOS 17.0, *) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(quoteArr, id: \.self) { quote in
                            FeedCellScr(quote: quote, showInfo: .constant(false), showCateOnTop: .constant(false))
                                .frame(width: UIScreen.width, height: UIScreen.height)
                                .onAppear {
                                    Task {
                                        try await cellAppear(quote: quote)
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
                        await fetchQuotes()
                    }
                }
                .ignoresSafeArea()
            } else {
                Text("DEBUG_18: Damn! update to iOS 17+!")
            }
            
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
    
    private func cellAppear(quote: Quote) async throws {
        print("DEBUG_18: cell \(quote.orderNo)")
        let last = UserDefaults.standard.object(forKey: UserDe.quote_last) as? String ?? "nil"
        
        if quote.script == last {
            print("DEBUG_18: last quote")
            do {
                try await continueFetch()
            } catch {
                print("DEBUG_18: error fetching quotes, \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchQuotes() async {
        guard let cateP = catePath else { return }
        
        quoteArr = await ServiceFetch.shared.fetchQuotesFromACate(title: cateP.getTitle(), cate: cateP.getCate())
        UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: UserDe.quote_last)
        
        for quote in quoteArr {
            duplArr.append(quote.orderNo)
        }
    }
    
    private func continueFetch() async throws {
        //handle int arr
        guard let cateP = catePath else { return }
        var randArr = try await ServiceFetch.shared.randIntArr(title: cateP.getTitle(), cate: cateP.getCate(), both: true)
        randArr = randArr.filter { !duplArr.contains($0) }
        if randArr.isEmpty {
            print("DEBUG_18: no more quotes on \(cateP)")
            return
        }
        
        //fetch new quotes and append to current arr
        let newQuoteArr = try await ServiceFetch.shared.fetchQuotes(title: cateP.getTitle(), cate: cateP.getCate(), randArr: randArr)
        if !newQuoteArr.isEmpty {
            quoteArr += newQuoteArr
        }
        UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: UserDe.quote_last)
        
        duplArr += randArr
        print("DEBUG_18: duplArr now \(duplArr)")
    }
    
    private func followFunc() {
        if let cateP = catePath {
            if isFollowing() {
                chosenCatePathArr = chosenCatePathArr.filter { $0 != cateP }
                removeCateForYou = cateP
            } else {
                chosenCatePathArr.append(cateP)
                addCateForYou = cateP
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
    CateQuotesScreen(showCateQuotesScr: .constant(false), chosenCatePathArr: .constant(["haha"]), removeCateForYou: .constant("haha"), addCateForYou: .constant("hha"))
}
