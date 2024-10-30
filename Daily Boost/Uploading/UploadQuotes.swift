//
//  UploadQuote.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/26/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class ServiceUpload {
    
    static let share = ServiceUpload()
    
//MARK: - Function
    
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

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" //length = 62
    return String((0..<length).map{ _ in letters.randomElement()! })
}
