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
    @Published var user: User = User.initState //ex: user.cateArr = ["Productivity/Discipline"]
    @Published var themeUIImage: UIImage = UIImage(named: "wall1")!
    
    @Published var quoteArr: [Quote] = []
    @Published var refetch = false
    @Published var quoteCount = 0
    
    @Published var showCate = false
    @Published var showSetting = false
    @Published var showTheme = false
    @Published var showLoading = false
    @Published var showStreak = false
            
//MARK: - Function Appear
    
    func fetchUser() async {
        print("DEBUG_1: fetching user info...")
        let uid = userID ?? ""
        do {
            user = try await         ServiceFetch.shared.fetchUserInfo(userID: uid)
            print("DEBUG_1: done fetching userInfo")
            UserDefaults.standard.set(user.fictionOption, forKey: UserDe.fictionOption)
        } catch {
            let e = error.localizedDescription
            print("DEBUG_1: err \(e)")
        }
    }
    
    func insertNotiQuote(quoteP: String) async -> Quote {
        let quote = await ServiceFetch.shared.fetchAQuote(title: quoteP.getTitle(), cate: quoteP.getCate(), orderNo: Int(quoteP.getOrderNo()) ?? 0)
        return quote
    }
    
    func loadHomeScreen() async {
        
        if userID != nil {
            print("DEBUG_1: userID is \(userID ?? "nil")")
            
            //fetch histArr
            print("DEBUG_1: histArr init count \(user.histArr.count)")
            
            await displayQuotes()
            
            //save last_fetched_quote for pagination
            UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: UserDe.last_fetched_Q)
            
            showLoading = false
            try? await Task.sleep(nanoseconds: 0_100_000_000)//delay
            
            let justLogin = UserDefaults.standard.object(forKey: UserDe.justLogin) as? Bool ?? false
            
            if justLogin {
                UserDefaults.standard.set(1, forKey: UserDe.currentStreak)
                UserDefaults.standard.set(Date.now, forKey: UserDe.lastDayOpened)
                let currentS = 86400-getCurrentS()
                UserDefaults.standard.set(currentS, forKey: UserDe.lastSecTilMidnight)
                
                UserDefaults.standard.set(false, forKey: UserDe.justLogin)
                
                showStreak = true
                await setAllNoti(user: user)
            } else {
                checkStreak()
                if getDiffsDay() != 0 {
                    await setAllNoti(user: user)
                } else {
                    print("DEBUG_1: same day, no new noti.")
                }
            }
                        
        } else {
            print("DEBUG_1: no userID, user logged out")
            showLoading = false
        }
    }
    
    func refetchTriggered() async {
        showLoading = true
        quoteArr.removeAll()
        
        await displayQuotes()
        print("DEBUG_1: done refetching")
        
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
        
        //configure histArr
        await configHistArr(quote: quote, id: quoteID)
        
        //check for last-fetched quote b4 fetching new quotes
        await checkLastQuote(quote: quote)
        
    }
    
    
    func notiChange(notiQPath: String) async {
        showCate = false
        showSetting = false
        showTheme = false
        
        await refetchTriggered()
        
        //for notification
        if !notiQPath.isEmpty {
            let q = await insertNotiQuote(quoteP: notiQPath)
            quoteArr.insert(q, at: 0)
        }
    }
    
    func screenAppear(notiQPath: String) async {
        showLoading = true
        await fetchUser()
        
        //for tapping notification
        if notiQPath.isEmpty {
            await loadHomeScreen() //check streak, set all noti
            
        } else { //app opens from noti
            try? await Task.sleep(nanoseconds: 1_000_000_000)//delay 1s
            checkStreak()
            
            if getDiffsDay() != 0 {
                await setAllNoti(user: user)
            } else {
                print("DEBUG_1: same day, zero new noti set.")
            }
        }
        
    }
    
//MARK: - Private func (Cell appear)
    
    private func configHistArr(quote: Quote, id: String) async {
        let uid = userID ?? "nil"
        
        let arr = user.histArr.filter { $0 == id }
        if arr.isEmpty { //no dupl & lastQ must NOT be mockQuote
            if user.histArr.count == DB_QUOTE_HIST {
                user.histArr.removeFirst()
            }
            
            user.histArr.append(id)

            //update to DB
            if user.histArr.count > 0 {
                await ServiceUpload.shared.updateQuoteHist(userID: uid, histArr: user.histArr)
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
            await displayQuotes()
            print("DEBUG_1: New fetch with hist! now having \(quoteArr.count) quotes")
            
            //save last_fetched_quote for pagination
            UserDefaults.standard.set(quoteArr[quoteArr.count-1].script, forKey: UserDe.last_fetched_Q)
        }
    }
    
//MARK: - Private Func (Screen appear)
    
    //we make user must choose at least 1 cate
    private func displayQuotes() async {
        user.cateArr = user.cateArr.isEmpty ? ["Love yourself/Motivation"] : user.cateArr //empty state (just in case)

        var iterate = 0
        
        var newQ = Quote.mockQuote
        var inHist = true
        
        while inHist {
            iterate += 1
            if iterate == 21 {
                inHist = false //only give 20 attempts (21-1)
                newQ = Quote.mockQuote
            } else {
                let randPath = user.cateArr.randomElement()!
                newQ = await ServiceFetch.shared.fetchARandQuote(title: randPath.getTitle(), cate: randPath.getCate())
                inHist = existInHist(quoteNeedFilter: newQ)
            }
        }
        quoteArr.append(newQ)
    }
    
    private func existInHist(quoteNeedFilter: Quote) -> Bool {
        let qID = "\(quoteNeedFilter.title)/\(quoteNeedFilter.category)#\(quoteNeedFilter.orderNo)"
        let arr = user.histArr.filter { $0 == qID }
        if !arr.isEmpty {  //found in histArr
            print("DEBUG_1: founded \(qID) in histArr")
            return true
        } else {
            return false
        }
    }
    
    
//MARK: Streak func -------
    
    func getDiffsDay() -> Int {
        let lastDayOpened = UserDefaults.standard.object(forKey: UserDe.lastDayOpened) as? Date ?? Date.now
        let lastSecTilMidnight = UserDefaults.standard.object(forKey: UserDe.lastSecTilMidnight) as? Int ?? 1
        let diffs = Calendar.current.dateComponents([.second], from: lastDayOpened, to: Date.now)
        let diffsSec = diffs.second ?? 0
        
        if (diffsSec > lastSecTilMidnight) && (diffsSec < lastSecTilMidnight + 86400) {
            return 1 //user opens app next day
        } else if diffsSec > (lastSecTilMidnight + 86400) {
            return 2 //streak terminate
        } else { //same day
            return 0
        }
    }
    
    func checkStreak() {
        print("DEBUG_1: checking streak...")
        var currentStreak = UserDefaults.standard.object(forKey: UserDe.currentStreak) as? Int ?? 1
        let diffsDay = getDiffsDay()
        
        if diffsDay == 1 {
            //show continue streak
            print("DEBUG_1: diffsDay is \(diffsDay), streak \(currentStreak), now plus 1")
            
            currentStreak += 1
            UserDefaults.standard.set(currentStreak, forKey: UserDe.currentStreak)
            UserDefaults.standard.set(Date.now, forKey: UserDe.lastDayOpened)
            let currentS = 86400-getCurrentS()
            UserDefaults.standard.set(currentS, forKey: UserDe.lastSecTilMidnight)
            
            showStreak = true
            
        } else if diffsDay > 1 {
            //show streak 1 day
            print("DEBUG_1: diffsDay is \(diffsDay), streak terminated")
            
            currentStreak = 1
            UserDefaults.standard.set(currentStreak, forKey: UserDe.currentStreak)
            UserDefaults.standard.set(Date.now, forKey: UserDe.lastDayOpened)
            let currentS = 86400-getCurrentS()
            UserDefaults.standard.set(currentS, forKey: UserDe.lastSecTilMidnight)
            
            showStreak = true
            
        } else { //diffsDay == 0
            //nothing
            print("DEBUG_1: same day open, currentStreak \(currentStreak)")
        }
    }
    
    
}
