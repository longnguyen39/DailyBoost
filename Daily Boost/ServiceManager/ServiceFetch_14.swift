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
    
    //MARK: - Functions
    
    func fetchQuotes(title: String, cate: String, randArr: [Int]) async throws -> [Quote] {
        let ref = Firestore.firestore().collection(title).document(cate).collection(DB_CATETITLE_COLL)
        let snapshot = try await ref.whereField("orderNo", in: randArr).getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: Quote.self) }) //loop snapshot, map (sort) all info and cast them as type Quote, return [Quote]
    }
    
    func fetchQuoteCount(title: String, cate: String) async -> Int {
        let countQuery = Firestore.firestore().collection(title).document(cate).collection(DB_CATETITLE_COLL).count
        do {
            let snapshot = try await countQuery.getAggregation(source: .server)
            return Int(truncating: snapshot.count)
        } catch {
            print(error)
            return 0
        }
    }
    
    func fetchQuotePaths(userID: String) async throws -> [QuotePath] {
        let docRef = Firestore.firestore().collection(DB_USER_COLL).document(userID)
        var arr: [QuotePath] = []
        
        do {
//            let query = try await coll.getDocuments()
//            for doc in query.documents {
//                let cate = doc.get(DB_QP_CATE) as? String ?? "nil"
//                let title = doc.get(DB_QP_TITLE) as? String ?? "nil"
//                arr.append(QuotePath(title: title, cate: cate))
//            }
            
            let doc = try await docRef.getDocument()
            if doc.exists {
                let data = doc.data()
            }
            
            return arr
        } catch {
            print("DEBUG_: error fetching QuotePath \(error.localizedDescription)")
            return []
        }
    }
}
