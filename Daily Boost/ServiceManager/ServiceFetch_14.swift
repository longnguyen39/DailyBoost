//
//  FetchQuotes.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/26/24.
//

import Foundation
import Firebase

class ServiceFetch {
    
    static let shared = ServiceFetch()
    
    //MARK: - Functions Quote
    
    func fetchQuotes(title: String, cate: String, randArr: [Int]) async throws -> [Quote] {
        let ref = Firestore.firestore().collection(title).document(cate).collection(DB_CATETITLE_COLL)
        let snapshot = try await ref.whereField("orderNo", in: randArr).getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: Quote.self) }) //loop snapshot, map (sort) all info and cast them as type Quote, return [Quote]
    }
    
    func fetchQuotesFromACate(title: String, cate: String) async -> [Quote] {
        do {
            let randArr = try await randIntArr(title: title, cate: cate) //arr of int
            print("DEBUG_14: randIntArr is \(randArr)")
            return try await fetchQuotes(title: title, cate: cate, randArr: randArr)
        } catch {
            let err = error.localizedDescription
            print("DEBUG_14: err fetching quotes: \(err)")
            return []
        }
    }
    
    func fetchQuoteCount(title: String, cate: String) async -> Int {
        let countQuery = Firestore.firestore().collection(title).document(cate).collection(DB_CATETITLE_COLL).count
        do {
            let snapshot = try await countQuery.getAggregation(source: .server)
            return Int(truncating: snapshot.count)
        } catch {
            print("DEBUG_14: err \(error.localizedDescription)")
            return 0
        }
    }
    
    func checkDuplicatedQuote(title: String, cate: String, script: String) async throws -> Bool {
        
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
        let docRefUser = Firestore.firestore().collection(DB_USER_COLL).document(userID)
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
    
    func fetchHistArr(userID: String) async -> [String] {
        let docRefUser = Firestore.firestore().collection(DB_USER_COLL).document(userID)
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
    
}
