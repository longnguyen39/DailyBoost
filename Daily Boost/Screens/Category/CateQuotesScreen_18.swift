//
//  CateQuotesScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 9/12/24.
//

import SwiftUI

struct CateQuotesScreen: View {
    @AppStorage(CATEPATH_CATEQUOTES) var catePath: String?
    
    @Binding var showCateQuotes: Bool
    @Binding var chosenCatePathArr: [String]
    @Binding var removeCateForYou: String
    @Binding var addCateForYou: String
    
    @State var quoteArr: [Quote] = []
    @State var duplArr: [Int] = []
        
    var body: some View {
        NavigationView {
            ZStack {
                if #available(iOS 17.0, *) {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(quoteArr, id: \.self) { quote in
                                FeedCellScr(quote: quote, isMainScreen: false, showInfo: .constant(false), showCateOnTop: .constant(false))
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
            }
            .navigationTitle(catePath?.getCate() ?? "Error")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showCateQuotes.toggle()
                    } label: {
                        Image(systemName: "chevron.down")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                    }
                    
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        followFunc()
                    } label: {
                        Text(isFollowing() ? "Following" : "Follow")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(isFollowing() ? .indigo : .blue)
                    }
                    
                }
            }
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
        var randArr = try await randIntArr(title: cateP.getTitle(), cate: cateP.getCate())
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
    CateQuotesScreen(showCateQuotes: .constant(false), chosenCatePathArr: .constant(["haha"]), removeCateForYou: .constant("haha"), addCateForYou: .constant("hha"))
}
