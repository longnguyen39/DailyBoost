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
    
    //MARK: - Functions
    
    func updateCatePathArr(userID: String, cateArr: [String]) async throws {
        let ref = Firestore.firestore().collection(DB_USER_COLL).document(userID)
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
        let ref = Firestore.firestore().collection(DB_USER_COLL).document(userID)
        do {
            try await ref.updateData([
                DB_User.histArr: histArr
            ])
            print("DEBUG_15: done updating histArr")
        } catch {
            print("DEBUG_15: err updating histArr, \(error.localizedDescription)")
        }
    }
    
}
