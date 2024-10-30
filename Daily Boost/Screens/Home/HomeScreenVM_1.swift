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
            
            try? await Task.sleep(nanoseconds: 0_200_000_000)//delay
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
        
        try? await Task.sleep(nanoseconds: 0_200_000_000)//delay
        showLoading = false
    }
    
    func cellAppear(quote: Quote) async {
        let quoteID = "\(quote.title)/\(quote.category)#\(quote.orderNo)"
        let uid = userID ?? "nil"
        
        print("DEBUG_1: presenting quote \(quoteID)")
        self.quoteInfo = quote //to properly display InfoScr
        
        //config welcome message
        if quote.script == Quote.quoteFirst.script {
            UserDefaults.standard.set(true, forKey: UserDe.did_welcome)
        }
        
        //configure histArr
        if quote.orderNo != 0 {
            let arr = histArr.filter { $0 == quoteID }
            if arr.isEmpty { //no dupl
                histArr.append(quoteID)
                
                if histArr.count > DB_QUOTE_HIST {
                    histArr.removeFirst()
                    print("DEBUG_1: just add new quote to hist, histArr count \(histArr.count)")
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
        
        //check for last-fetched quote b4 fetching new quotes
        let last = UserDefaults.standard.object(forKey: UserDe.last_fetched_Q) as? String ?? "nil"
        if quote.script == last {
            print("DEBUG_1: this is the last quote")
            
            //fetch new arr of quotes (with hist check)
            
        }
    }
    
    //MARK: - FUNCTIONS
    
    func displayQuotes() async {
        
        //remove welcome message
        let didWelcome = UserDefaults.standard.object(forKey: UserDe.did_welcome) as? Bool ?? false
        if didWelcome && quoteArr.count != 0 {
            quoteArr.removeFirst()
        }
        
        //fetch quotePath
        chosenCatePathArr = await ServiceFetch.shared.fetchCatePath(userID: userID ?? "nil")
        
        var displayQuoteArr = [Quote]()
        for catePath in chosenCatePathArr {
            let arr = await ServiceFetch.shared.fetchQuotesFromACate(title: catePath.getTitle(), cate: catePath.getCate())
            displayQuoteArr += arr
        }
        quoteArr += displayQuoteArr.shuffled()
        
        //subtract from histArr
        for quote in quoteArr {
            let qID = "\(quote.title)/\(quote.category)#\(quote.orderNo)"
            let arr = histArr.filter { $0 == qID }
            if !arr.isEmpty {  //found in histArr
                print("DEBUG_1: founded \(qID) in histArr, subtract!")
                quoteArr = quoteArr.filter { "\($0.title)/\($0.category)#\($0.orderNo)" != qID }
            }
        }
        quoteArr = quoteArr.shuffled() //more shuffle after hist check for randomness
        print("DEBUG_1: after checking hist, now displaying \(quoteArr.count) quotes")
        
        //check for empty quoteArr (user chooses no cate)
        if quoteArr.count == 0 {
            quoteArr = Quote.quoteEmptyArr
        }
    }
    
    
}
