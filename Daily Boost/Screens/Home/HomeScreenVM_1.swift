//
//  HomeScreenVM.swift
//  Daily Boost
//
//  Created by Long Nguyen on 9/24/24.
//

import SwiftUI

class HomeScreenVM: ObservableObject {
    
    @AppStorage(currentUserDefaults.userID) var userID: String? //this on constantly pull data from userDefaults (if data from userDefaults change, it also changes live)
    @AppStorage(currentUserDefaults.username) var username: String?
    
    @Published var quoteArr = [Quote.quoteFirst]
    @Published var chosenCatePathArr: [String] = [] //ex: "Productivity/Discipline"
    @Published var refetch = false
    @Published var quoteCount = 0
    
    @Published var showInfo = false
    @Published var showCate = false
    @Published var showSetting = false
    @Published var showTheme = false
    
    @Published var quoteInfo = Quote.quoteFirst
    
    //MARK: - Function Appear
    
    func screenAppear() async {
        await displayQuotes()
        print("DEBUG_1: done fetching \(quoteArr.count) quotes")
        
        UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: USER_D_LAST_FETCHED_Q)
        
        if userID != nil {
            print("DEBUG_1: userID is \(userID ?? "nil")")
        } else {
            print("DEBUG_1: no userID")
        }
    }
    
    func refetchTriggered() async {
        chosenCatePathArr.removeAll()
        quoteArr.removeAll()
        
        await displayQuotes()
        print("DEBUG_1: done refetching \(quoteArr.count) quotes")
        
        UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: USER_D_LAST_FETCHED_Q)
    }
    
    func cellAppear(quote: Quote) {
        print("DEBUG_1: cell \(quote)")
        self.quoteInfo = quote //to properly display InfoScr
        
        if quote.script == Quote.quoteFirst.script {
            UserDefaults.standard.set(true, forKey: USER_D_DID_WELCOME)
        }
        
        let last = UserDefaults.standard.object(forKey: USER_D_LAST_FETCHED_Q) as? String ?? "nil"
        if quote.script == last {
            print("DEBUG_1: this is the last quote")
        }
    }
    
    //MARK: - FUNCTIONS
    
    func displayQuotes() async {
        
        //remove welcome message
        let didWelcome = UserDefaults.standard.object(forKey: USER_D_DID_WELCOME) as? Bool ?? false
        if didWelcome && quoteArr.count != 0 {
            quoteArr.removeFirst()
        }
        
        //fetch quotePath
        await fetchCatePaths()
        
        var displayQuoteArr = [Quote]()
        for catePath in chosenCatePathArr {
            let quotes = await ServiceFetch.shared.fetchQuotesFromACate(title: catePath.getTitle(), cate: catePath.getCate())
            displayQuoteArr += quotes
        }
        quoteArr += displayQuoteArr.shuffled()
        
        if quoteArr.count == 0 {
            quoteArr = Quote.quoteEmptyArr
        }
    }
    
    func fetchCatePaths() async {
        do {
            chosenCatePathArr = try await ServiceFetch.shared.fetchCatePath(userID: userID ?? "nil")
        } catch {
            print("DEBUG_1: err fetch quotePaths \(error.localizedDescription)")
        }
    }
    
    
}
