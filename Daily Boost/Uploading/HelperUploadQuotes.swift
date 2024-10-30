//
//  HelperUploadQuotes.swift
//  Daily Boost
//
//  Created by Long Nguyen on 9/1/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class HelperUploadQuotes {
    
    static let share = HelperUploadQuotes()
    
//MARK: - Function
    
    //call this first, then uploadOneQuote later
    func uploadCateTitle(quote: Quote) async throws {
        let DB_QUOTE = Firestore.firestore().collection(quote.title)
        let uploadCate = DB_QUOTE.document(quote.category)
        try? await uploadCate.setData([
            DB_CateTitle_count: quote.orderNo,
            DB_CateTitle_fiction: 0,
            DB_CateTitle_nonf: 0,
            DB_CateTitle_authCount: 0,
            DB_CateTitle_Ano: 0,
            DB_CateTitle_time: Date.now,
        ])
    }
    
    func uploadOneQuote(quote: Quote) async throws {
        let quoteID = "\(randomString(length: 10))_\(quote.orderNo)"
        let DB_QUOTE = Firestore.firestore().collection(quote.title)
        let uploadQuote = DB_QUOTE.document(quote.category).collection(DB_CATETITLE_COLL).document(quoteID)
        guard let encodedQuote = try? Firestore.Encoder().encode(quote) else { return }
        
        try? await uploadQuote.setData(encodedQuote)
    }
    
}
