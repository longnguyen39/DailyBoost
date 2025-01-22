//
//  FetchQuotes.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/26/24.
//

import Foundation
import Firebase
import SwiftUI

class ServiceFetch {
    
    static let shared = ServiceFetch()
    
    @AppStorage(UserDe.fictionOption) var fictionOption: String?
    
//MARK: - Functions Quote
    
    func fetchQuotesFromACate(title: String, cate: String) async -> [Quote] {
        do {
            let randArr = try await randIntArr(title: title, cate: cate, both: false) //arr of int
            print("DEBUG_14: randIntArr \(title)/\(cate) is \(randArr)")
            return try await fetchQuotes(title: title, cate: cate, randArr: randArr)
        } catch {
            let err = error.localizedDescription
            print("DEBUG_14: err fetching quotes: \(err)")
            return []
        }
    }
    
    func fetchQuotes(title: String, cate: String, randArr: [Int]) async throws -> [Quote] {
        let ref = Firestore.firestore().collection(title).document(cate).collection(DB_CATETITLE_COLL)
        let snapshot = try await ref.whereField("orderNo", in: randArr).getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: Quote.self) }) //loop snapshot, map (sort) all info and cast them as type Quote, return [Quote]
    }
    
    func fetchQuoteCount(title: String, cate: String, isFiction: Bool) async -> Int {
        
        let countQuery = Firestore.firestore().collection(title).document(cate).collection(DB_CATETITLE_COLL).whereField("isFictional", isEqualTo: isFiction).count
        do {
            let snapshot = try await countQuery.getAggregation(source: .server)
            return Int(truncating: snapshot.count)
        } catch {
            print("DEBUG_14: err \(error.localizedDescription)")
            return 0
        }
    }
    
    func randIntArr(title: String, cate: String, both: Bool) async throws -> [Int] { //screen 18 uses this
        
        //non-fiction
        let countQueryNF = Firestore.firestore().collection(title).document(cate).collection(DB_CATETITLE_COLL).whereField("isFictional", isEqualTo: false).count
        let snapshotNF = try await countQueryNF.getAggregation(source: .server)
        let countNonF = Int(truncating: snapshotNF.count)
        
        //fiction
        let countQueryF = Firestore.firestore().collection(title).document(cate).collection(DB_CATETITLE_COLL).whereField("isFictional", isEqualTo: true).count
        let snapshotF = try await countQueryF.getAggregation(source: .server)
        let countF = Int(truncating: snapshotF.count)
                
        if both { //for screen 18
            let bothArr = randIntNonF(countNF: countNonF) + randIntF(countF: countF)
            return bothArr.shuffled()
            
        } else { //set arr
            let option = fictionOption ?? "none"
            print("DEBUG_14: now fetch \(option)")
            
            if fictionOption == FictionOption.nonFiction.name {
                return randIntNonF(countNF: countNonF)
            } else if fictionOption == FictionOption.fiction.name {
                return randIntF(countF: countF)
            } else { //both
                let bothArr = randIntNonF(countNF: countNonF) + randIntF(countF: countF)
                return bothArr.shuffled()
            }
        }
    }
    
    private func randIntNonF(countNF: Int) -> [Int] {
        var arr: [Int] = []
        if countNF >= 1 { //must have >1 quote for that cate
            for _ in 1...3 { // 3 attempts for each cate
                let randNF = Int.random(in: 1...countNF)
                arr.append(randNF)
            }
            return arr.removingDuplicates()
        } else {
            print("DEBUG_14: countNF is \(countNF)")
            return [1]
        }
    }
    
    private func randIntF(countF: Int) -> [Int] {
        var arr: [Int] = []
        if countF >= 1 { //must have >1 quote for that cate
            for _ in 1...3 { // 3 attempts for each cate
                let randF = Int.random(in: 1000001...countF+1000000)
                arr.append(randF)
            }
            return arr.removingDuplicates()
        } else {
            print("DEBUG_14: countF is \(countF)")
            return [1]
        }
    }
    
    func checkDuplicatedQuote(title: String, cate: String, script: String) async -> Bool {
        
        let snapshot = Firestore.firestore().collection(title).document(cate).collection(DB_CATETITLE_COLL).whereField("script", isEqualTo: script)
        
        do {
            let querySnapshot = try await snapshot.getDocuments()
            return !querySnapshot.documents.isEmpty //if no dupl found, return false
        } catch {
            print("DEBUG_14: error fetching duplicated script \(error.localizedDescription)")
            return true
        }
    }
    
//MARK: - Functions UserID
    
    func fetchCatePath(userID: String) async -> [String] {
        let docRefUser = Firestore.firestore().collection(DB_User.coll).document(userID)
        var arr: [String] = []
        
        do {
            let doc = try await docRefUser.getDocument()
            if doc.exists {
                let user = try? doc.data(as: User.self)
                arr = user?.cateArr ?? []
            } else {
                print("DEBUG_14: doc of user is not exist")
            }
            return arr
        } catch {
            print("DEBUG_14: error fetching QuotePath \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchUserInfo(userID: String) async throws -> User {
        let ref = Firestore.firestore().collection(DB_User.coll).document(userID)
        let doc = try await ref.getDocument()
        return try doc.data(as: User.self)
    }
    
    func fetchHistArr(userID: String) async -> [String] {
        let docRefUser = Firestore.firestore().collection(DB_User.coll).document(userID)
        var arr: [String] = []
        
        do {
            let doc = try await docRefUser.getDocument()
            if doc.exists {
                let user = try? doc.data(as: User.self)
                arr = user?.histArr ?? []
            } else {
                print("DEBUG_14: user's doc no exist")
            }
            return arr
        } catch {
            print("DEBUG_14: error fetching histArr \(error.localizedDescription)")
            return []
        }
    }
    
//MARK: - Functions LikeQuote
    
    func fetchLikeQuotes(userID: String) async throws -> [LikeQuote] {
        let ref = Firestore.firestore().collection(DB_User.coll).document(userID).collection(DB_User.like_coll)
        let snapshot = try await ref.order(by: "timeStamp", descending: true).limit(to: 10).getDocuments()
        let arr = snapshot.documents.compactMap({ try? $0.data(as: LikeQuote.self) }) //loop snapshot, map (sort) all info and cast them as type Quote, return [Quote]
        
        //save for pagination
//        UserDefaults.standard.set(arr[arr.count-1].catePath, forKey: UserDe.last_fetched_likeQPath)
//        UserDefaults.standard.set(arr[arr.count-1].timeStamp, forKey: UserDe.last_fetched_likeQTime)

        return arr
    }
    
//    func paginateLikeQuotes(userID: String) async throws -> [LikeQuote] {
//        let lastTime = UserDefaults.standard.object(forKey: UserDe.last_fetched_likeQTime) as? Date ?? Date.now
//        
//        let ref = Firestore.firestore().collection(DB_User.coll).document(userID).collection(DB_User.like_coll)
//        let snapshot = try await ref
//            .whereField("timeStamp", isLessThan: lastTime)
//            .order(by: "timeStamp", descending: true)
//            .limit(to: 5).getDocuments()
//        let arr = snapshot.documents.compactMap({ try? $0.data(as: LikeQuote.self) }) //loop snapshot, map (sort) all info and cast them as type Quote, return [Quote]
//        
//        //save for pagination
//        UserDefaults.standard.set(arr[arr.count-1].catePath, forKey: UserDe.last_fetched_likeQPath)
//        UserDefaults.standard.set(arr[arr.count-1].timeStamp, forKey: UserDe.last_fetched_likeQTime)
//        
//        return arr
//    }
    
    
//MARK: - Functions Theme fetching
    
    func fetchAllThemeImgsOfATitle(themeTitle: String) async throws -> [UIImage] {
        let themes = try await fetchThemesFromATitle(themeTitle: themeTitle)
        var themeImgArr: [UIImage] = []
        
        for theme in themes {
            ThemeManager.shared.fetchAThemeImage(themeTitle: themeTitle, fileName: theme.fileName) { uiImage in
                if let uiImg = uiImage {
                    themeImgArr.append(uiImg)
                }
            }
        }
        
        return themeImgArr
    }
    
    func fetchThemesFromATitle(themeTitle: String) async throws -> [Theme] {
        let ref = Firestore.firestore().collection(DB_Theme.coll).document(themeTitle).collection(DB_Theme.img)
        
        let snapshot = try await ref.getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: Theme.self) }) //loop snapshot, map (sort) all info and cast them as type Theme, return [Theme]
    }
    
}
