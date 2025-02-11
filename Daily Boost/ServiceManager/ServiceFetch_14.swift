//
//  FetchQuotes.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/26/24.
//

import Foundation
import Firebase
import SwiftUI

var pagiSnapshot: QueryDocumentSnapshot?

class ServiceFetch {
    
    static let shared = ServiceFetch()
    
    @AppStorage(UserDe.fictionOption) var fictionOption: String?
    
//MARK: - Functions Quote
    
    func fetchARandQuote(title: String, cate: String) async -> Quote {
        let randInt = await generateRandInt(title: title, cate: cate, showOneCate: false, count_nf: -1, count_f: -1)
        print("DEBUG_14: randInt \(title)/\(cate) is \(randInt)")
        return await fetchAQuote(title: title, cate: cate, orderNo: randInt)
    }
    
    //supposed to return arr of ONLY 1 element
    func fetchAQuote(title: String, cate: String, orderNo: Int) async -> Quote {
        let ref = Firestore.firestore().collection(title).document(cate).collection(DB_CATETITLE_COLL)
        
        do {
            let snapshot = try await ref.whereField("orderNo", isEqualTo: orderNo).getDocuments()
            let arr = snapshot.documents.compactMap({ try? $0.data(as: Quote.self) }) //loop snapshot, map (sort) all info and cast them as type Quote, return [Quote]
            return arr.first ?? Quote.mockQuote
        } catch {
            print("DEBUG_14: err fetch a quote")
            return Quote.mockQuote
        }
        
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
    
    func generateRandInt(title: String, cate: String , showOneCate: Bool, count_nf: Int, count_f: Int) async -> Int { //screen 18 uses this
        
        var countNF = 0
        var countF = 0
        
        if showOneCate {
            countNF = count_nf
            countF = count_f
        } else {
            countNF = await fetchQuoteCount(title: title, cate: cate, isFiction: false)
            countF = await fetchQuoteCount(title: title, cate: cate, isFiction: true)
        }
        
        //arr has 1 F quote and 1 NF quote
        var bothArr: [Int] = []
        if countF == 0 {
            bothArr = [Int.random(in: 1...countNF)]
        } else {
            bothArr = [Int.random(in: 1...countNF), Int.random(in: 1000001...countF+1000000)]
        }
//        bothArr = [Int.random(in: 1...countNF), Int.random(in: 1000001...countF+1000000)]
        
        //return rand int
        if showOneCate { //for CateQuoteScr_18
            return bothArr.randomElement()!
            
        } else { //set arr
            let option = fictionOption ?? "none"
            print("DEBUG_14: now fetch \(option)")
            
            if fictionOption == FictionOption.nonFiction.name {
                return Int.random(in: 1...countNF)
            } else if fictionOption == FictionOption.fiction.name {
                if countF == 0 {
                    return 0
                } else {
                    return Int.random(in: 1000001...countF+1000000)
                }
            } else { //both
                return bothArr.randomElement()!
            }
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
            return arr.shuffled()
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
    
    func fetchLikeQCount(userID: String) async -> Int {
        let ref = Firestore.firestore().collection(DB_User.coll).document(userID).collection(DB_User.like_coll).count
        do {
            let snapshot = try await ref.getAggregation(source: .server)
            return Int(truncating: snapshot.count)
        } catch {
            print("DEBUG_14: err likeQ count \(error.localizedDescription)")
            return 0
        }
    }
    
    func fetchLikeQuotes(userID: String) async throws -> [LikeQuote] {
        let ref = Firestore.firestore().collection(DB_User.coll).document(userID).collection(DB_User.like_coll)
        let snapshot = try await ref
            .order(by: "timeStamp", descending: true)
            .limit(to: 10)
            .getDocuments()
        
        guard let lastSnapshot = snapshot.documents.last else {
            return []
        }
        pagiSnapshot = lastSnapshot
        
        return snapshot.documents.compactMap({ try? $0.data(as: LikeQuote.self) }) //loop snapshot, map (sort) all info and cast them as type Quote, return [Quote]
    }
    
    func configPagiLikeQArr(userID: String) async throws -> [LikeQuote] {
        
        guard let lastSnapshot = pagiSnapshot else {
            return []
        }
        
        let ref = Firestore.firestore().collection(DB_User.coll).document(userID).collection(DB_User.like_coll)
        let snapshot = try await ref
            .order(by: "timeStamp", descending: true)
            .limit(to: 10)
            .start(afterDocument: lastSnapshot)
            .getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: LikeQuote.self) }) //loop snapshot, map (sort) all info and cast them as type Quote, return [Quote]
    }
    
    
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
