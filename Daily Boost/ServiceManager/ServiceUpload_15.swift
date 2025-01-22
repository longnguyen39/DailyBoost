//
//  ServiceUpload.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/21/24.
//

import Foundation
import Firebase

class ServiceUpload {
    
    static let shared = ServiceUpload()
    
//MARK: - User
    
    func updateUsername(userID: String, username: String) async throws {
        let ref = Firestore.firestore().collection(DB_User.coll).document(userID)
        try await ref.updateData([
            DB_User.username: username
        ])
    }
    
    func updateUserReminder(user: User) async throws {
        let ref = Firestore.firestore().collection(DB_User.coll).document(user.userID)
        try await ref.updateData([
            DB_User.start: user.start,
            DB_User.end: user.end,
            DB_User.howMany: user.howMany
        ])
    }
    
    func uploadLikeQuote(userID: String, quote: Quote) async {
        let likeCatePath = "\(quote.title)/\(quote.category)#\(quote.orderNo)"
        let docID = likeCatePath.replacingOccurrences(of: "/", with: "_")
        let likeQuote = LikeQuote(script: quote.script, catePath: likeCatePath, author: quote.author, timeStamp: Date.now)
        
        let ref = Firestore.firestore().collection(DB_User.coll).document(userID).collection(DB_User.like_coll).document(docID)
        
        guard let encodedQuote = try? Firestore.Encoder().encode(likeQuote) else { return }
        try? await ref.setData(encodedQuote)
    }
    
    func unLikeQuote(userID: String, quote: Quote?, likeQuote: LikeQuote?) async {
        
        var docID = ""
        if let q = quote {
            docID = "\(q.title)_\(q.category)#\(q.orderNo)"
        }
        if let lq = likeQuote {
            docID = lq.catePath.replacingOccurrences(of: "/", with: "_")
        }
        
        let ref = Firestore.firestore().collection(DB_User.coll).document(userID).collection(DB_User.like_coll).document(docID)
        
        do {
            print("DEBUG_15: unliking quote \(docID)")
            try await ref.delete()
        } catch {
            print("DEBUG_15: err deleting like quote, \(error.localizedDescription)")
        }
        
    }
    
//MARK: - Quote
    
    func updateCatePathArr(userID: String, cateArr: [String]) async {
        let ref = Firestore.firestore().collection(DB_User.coll).document(userID)
        do {
            try await ref.updateData([
                DB_User.cateArr: cateArr
            ])
            print("DEBUG_15: done updating cateArr")
        } catch {
            print("DEBUG_15: err updating cateArr, \(error.localizedDescription)")
        }
    }
    
    func updateQuoteHist(userID: String, histArr: [String]) async {
        let ref = Firestore.firestore().collection(DB_User.coll).document(userID)
        do {
            try await ref.updateData([
                DB_User.histArr: histArr
            ])
            print("DEBUG_15: done updating histArr")
        } catch {
            print("DEBUG_15: err updating histArr, \(error.localizedDescription)")
        }
    }
    
    func updateFictionOption(userID: String, opt: String) async {
        let ref = Firestore.firestore().collection(DB_User.coll).document(userID)
        do {
            try await ref.updateData([
                DB_User.fictionOption: opt
            ])
            print("DEBUG_15: done updating fictionOpt")
        } catch {
            print("DEBUG_15: err updating fictionOpt, \(error.localizedDescription)")
        }
    }
    
}
