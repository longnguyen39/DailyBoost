//
//  HomeScreenVM.swift
//  Daily Boost
//
//  Created by Long Nguyen on 9/24/24.
//

import SwiftUI

@MainActor //Main thread
class HomeScreenVM: ObservableObject {
    
    @AppStorage(currentUserDefaults.userID) var userID: String? //this on constantly pull data from userDefaults (if data from userDefaults change, it also changes live)
    @Published var user: User = User.initState
    
    @Published var quoteArr = [Quote.quoteFirst]
    @Published var chosenCatePathArr: [String] = [] //ex: "Productivity/Discipline"
    @Published var refetch = false
    @Published var quoteCount = 0
    
    @Published var showInfo = false
    @Published var showCate = false
    @Published var showCateTopLeft = true
    @Published var showSetting = false
    @Published var showTheme = false
    @Published var showLoading = false
    
    @Published var quoteInfo = Quote.quoteFirst
    var histArr: [String] = [] //ex: "Productivity/Discipline#4"
    
    //MARK: - Function Appear
    
    func fetchUser() async {
        let uid = userID ?? ""
        do {
            user = try await         ServiceFetch.shared.fetchUserInfo(userID: uid)
        } catch {
            let e = error.localizedDescription
            print("DEBUG_1: err \(e)")
        }
    }
    
    func screenAppear() async {
        showLoading = true
        
        if userID != nil {
            print("DEBUG_1: userID is \(userID ?? "nil")")
            
            //fetch histArr
            histArr += await ServiceFetch.shared.fetchHistArr(userID: userID ?? "nil")
            print("DEBUG_1: histArr init count \(histArr.count)")
            
            await displayQuotes()
            
            //save last_fetched_quote for pagination
            UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: UserDe.last_fetched_Q)
            
            try? await Task.sleep(nanoseconds: 0_100_000_000)//delay
            showLoading = false
            
        } else {
            print("DEBUG_1: no userID, user logged out")
            showLoading = false
        }
    }
    
    func refetchTriggered() async {
        showLoading = true
        chosenCatePathArr.removeAll()
        quoteArr.removeAll()
        
        await displayQuotes()
        print("DEBUG_1: done refetch \(quoteArr.count) quotes")
        
        UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: UserDe.last_fetched_Q)
        
        try? await Task.sleep(nanoseconds: 0_100_000_000)//delay
        showLoading = false
    }
    
    func cellAppear(quote: Quote) async {
        let quoteID = "\(quote.title)/\(quote.category)#\(quote.orderNo)"
        print("DEBUG_1: presenting quote: \(quoteID)")
        self.quoteInfo = quote //to properly display InfoScr
        
        //config welcome message
        if quote.script == Quote.quoteFirst.script {
            UserDefaults.standard.set(true, forKey: UserDe.did_welcome)
        }
        
        //configure histArr
        await configHistArr(quote: quote, id: quoteID)
        
        //check for last-fetched quote b4 fetching new quotes
        await checkLastQuote(quote: quote)
    }
    
    private func configHistArr(quote: Quote, id: String) async {
        let uid = userID ?? "nil"
        
        if quote.orderNo != 0 {
            let arr = histArr.filter { $0 == id }
            if arr.isEmpty { //no dupl
                histArr.append(id)
                
                if histArr.count > DB_QUOTE_HIST {
                    histArr.removeFirst()
                    print("DEBUG_1: histArr count \(histArr.count) after just adding new quote")
                }
                //update to DB
                if histArr.count > 0 {
                    await ServiceUpload.shared.updateQuoteHist(userID: uid, histArr: histArr)
                }
            } else {
                //happen when user swipe up (rewatch quotes)
                print("DEBUG_1: dupl, histArr no change")
            }
        }
    }
    
    private func checkLastQuote(quote: Quote) async {
        let last = UserDefaults.standard.object(forKey: UserDe.last_fetched_Q) as? String ?? "nil"
        if quote.script == last {
            print("DEBUG_1: this is the last quote")
            
            //fetch new arr of quotes (with hist check)
            var displayQuoteArr = await newlyFetchedQ()
            displayQuoteArr = filterFromHist(arrNeedFilter: displayQuoteArr)
            quoteArr += displayQuoteArr.shuffled()
            print("DEBUG_1: New fetch! Check hist! adding \(displayQuoteArr.count) quotes, now having \(quoteArr.count) quotes")
            
            //save last_fetched_quote for pagination
            UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: UserDe.last_fetched_Q)
        }
    }
    
    //MARK: - FUNCTIONS
    
    private func displayQuotes() async {
        
        //remove welcome message
        let didWelcome = UserDefaults.standard.object(forKey: UserDe.did_welcome) as? Bool ?? false
        if didWelcome && quoteArr.count != 0 {
            quoteArr.removeFirst()
        }
        
        //fetch quotePath
        chosenCatePathArr = await ServiceFetch.shared.fetchCatePath(userID: userID ?? "nil")
        
        //attach newly fetched quotes to quoteArr
        let displayQuoteArr = await newlyFetchedQ()
        quoteArr += displayQuoteArr.shuffled()
        
        //subtract from histArr
        quoteArr = filterFromHist(arrNeedFilter: quoteArr).shuffled() //more shuffle after hist check for randomness
        print("DEBUG_1: displaying \(quoteArr.count) quotes after checking hist")
        
        //check for empty quoteArr (user chooses no cate)
        if quoteArr.count == 0 {
            quoteArr = Quote.quoteEmptyArr
        }
    }
    
    private func newlyFetchedQ() async -> [Quote] {
        var displayQuoteArr = [Quote]()
        for catePath in chosenCatePathArr {
            let arr = await ServiceFetch.shared.fetchQuotesFromACate(title: catePath.getTitle(), cate: catePath.getCate())
            displayQuoteArr += arr
        }
        return displayQuoteArr.shuffled()
    }
    
    private func filterFromHist(arrNeedFilter: [Quote]) -> [Quote] {
        var arrFiltering = arrNeedFilter //arrNeedFilter cannot be changed
        
        for quote in arrFiltering {
            let qID = "\(quote.title)/\(quote.category)#\(quote.orderNo)"
            let arr = histArr.filter { $0 == qID }
            if !arr.isEmpty {  //found in histArr
                print("DEBUG_1: founded \(qID) in histArr, subtract!")
                arrFiltering = arrFiltering.filter { "\($0.title)/\($0.category)#\($0.orderNo)" != qID }
            }
        }
        return arrFiltering
    }
    
}
