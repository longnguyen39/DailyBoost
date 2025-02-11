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
    
    @Published var quoteArr: [Quote] = []
    @Published var chosenCatePathArr: [String] = [] //ex: "Productivity/Discipline"
    @Published var refetch = false
    @Published var quoteCount = 0
    
    @Published var showInfo = false
    @Published var showCate = false
    @Published var showCateTopLeft = true
    @Published var showSetting = false
    @Published var showTheme = false
    @Published var showLoading = false
    
    @Published var quoteInfo = Quote.mockQuote
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
    
    func insertNotiQuote(quoteP: String) async -> Quote {
        let quote = await ServiceFetch.shared.fetchAQuote(title: quoteP.getTitle(), cate: quoteP.getCate(), orderNo: Int(quoteP.getOrderNo()) ?? 0)
        return quote
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
        if quote.script == Quote.mockQuote.script {
            print("DEBUG_1: no more quote")
            return
        }
        
        let quoteID = "\(quote.title)/\(quote.category)#\(quote.orderNo)"
        print("DEBUG_1: presenting quote: \(quoteID)")
        self.quoteInfo = quote //to properly display InfoScr
        
        //configure histArr
        await configHistArr(quote: quote, id: quoteID)
        
        //check for last-fetched quote b4 fetching new quotes
        await checkLastQuote(quote: quote)
    }
    
    func loginDetect() async {
        let loginDetect = UserDefaults.standard.object(forKey: UserDe.loginDetected) as? Bool ?? false
        if loginDetect {
            print("DEBUG_1: login detected, setting noti...")
            //set noti
            await setNoti()
            UserDefaults.standard.set(false, forKey: UserDe.loginDetected)
        }
    }
    
//MARK: - Private func (Cell appear)
    
    private func configHistArr(quote: Quote, id: String) async {
        let uid = userID ?? "nil"
        
        let arr = histArr.filter { $0 == id }
        if arr.isEmpty { //no dupl & lastQ must NOT be mockQuote
            if histArr.count == DB_QUOTE_HIST {
                histArr.removeFirst()
            }
            
            histArr.append(id)

            //update to DB
            if histArr.count > 0 {
                await ServiceUpload.shared.updateQuoteHist(userID: uid, histArr: histArr)
            }
        } else {
            //happen when user swipe up (rewatch quotes)
            print("DEBUG_1: histArr no change, user rewatch \(id)")
        }
        
    }
    
    private func checkLastQuote(quote: Quote) async {
        let last = UserDefaults.standard.object(forKey: UserDe.last_fetched_Q) as? String ?? "nil"
        if quote.script == last {
            print("DEBUG_1: this is the last quote")
            
            //fetch a new quote (with hist check)
            await appendANewQ()
            print("DEBUG_1: New fetch with hist! now having \(quoteArr.count) quotes")
            
            //save last_fetched_quote for pagination
            UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: UserDe.last_fetched_Q)
        }
    }
    
//MARK: - Private Func (Screen appear)
    
    //we make user must choose at least 1 cate
    private func displayQuotes() async {
        chosenCatePathArr = await ServiceFetch.shared.fetchCatePath(userID: userID ?? "nil")
        await appendANewQ()
    }
    
    private func appendANewQ() async {
        var iterate = 0
        
        var newQ = Quote.mockQuote
        var inHist = true
        
        while inHist {
            iterate += 1
            if iterate == 21 {
                inHist = false //only give 20 attempts (21-1)
                newQ = Quote.mockQuote
            } else {
                let randPath = chosenCatePathArr.randomElement()!
                newQ = await ServiceFetch.shared.fetchARandQuote(title: randPath.getTitle(), cate: randPath.getCate())
                inHist = existInHist(quoteNeedFilter: newQ)
            }
        }
        quoteArr.append(newQ)
    }
    
    private func existInHist(quoteNeedFilter: Quote) -> Bool {
        let qID = "\(quoteNeedFilter.title)/\(quoteNeedFilter.category)#\(quoteNeedFilter.orderNo)"
        let arr = histArr.filter { $0 == qID }
        if !arr.isEmpty {  //found in histArr
            print("DEBUG_1: founded \(qID) in histArr")
            return true
        } else {
            return false
        }
    }
    
//MARK: Private func (others) -------
    
    private func setNoti() async {
        NotificationManager.shared.clearAllPendingNoti()
        
        var block = (user.end + 12 - user.start) * 60 / user.howMany
        block += (block / user.howMany) //based on testing
        
        for notiInt in 0..<user.howMany {
            if notiInt == user.howMany - 1 {
                await NotificationManager.shared.scheduleNoti(hour: user.end+12, min: 0, catePArr: chosenCatePathArr)
            } else {
                let t = (user.start * 60) + (notiInt * block)
                let hour = t / 60
                let min = t % 60
                await NotificationManager.shared.scheduleNoti(hour: hour, min: min, catePArr: chosenCatePathArr)
            }
        }
    }
    
}
