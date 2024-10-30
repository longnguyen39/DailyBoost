//
//  ServiceUpload.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/21/24.
//

import Foundation
import Firebase

class ServiceUpload {
    
    static let share = ServiceUpload()
    
    //MARK: - Functions
    
    func updateQuotePathArr(userID: String, cateArr: [QuotePath]) async throws {
        let ref = Firestore.firestore().collection(DB_USER_COLL).document(userID)
        do {
            try await ref.updateData([
                USER_INFO_cateArr: cateArr
            ])
        } catch {
            
        }
    }
    
}
