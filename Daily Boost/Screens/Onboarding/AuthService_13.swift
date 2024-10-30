//
//  AuthService.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/18/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

//we use "class" for AuthService
struct AuthService {
    
    static let shared = AuthService() //only 1 instance reused
    
    
//MARK: - Auth Function
//------------------------------------------------------
    
    func logOutUser(completion: @escaping(_ success: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            print("DEBUG_13: just sign out")
        } catch {
            print("DEBUG_13: error sign out \(error.localizedDescription)")
            completion(false)
            return
        }
        completion(true)
        
        //deleting all UserDefaults
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let defaultDict = UserDefaults.standard.dictionaryRepresentation()
            defaultDict.keys.forEach { key in
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
    
    
    @MainActor //execute on the main thread (where most UI works)
    func createUser(passedUser: User, cateArr: [String], completion: @escaping(Bool, String) -> Void) async throws {
        do {
            var user = passedUser
            user.email = generateEmail()
            
            let result = try await Auth.auth().createUser(withEmail: user.email, password: "DailyBoost_\(user.email)")
            await self.uploadUserData(userID: result.user.uid, passedUser: user, cateArr: cateArr) //wait until the result is set, then func executes. Before Async/Await, we gotta use completion block
            print("DEBUG_13: just done upload userInfo")
            completion(false, "")
        } catch {
            let e = error.localizedDescription
            completion(true, e)
        }
        
    }
    
//MARK: - API Function
//------------------------------------------------------
    
    private func uploadUserData(userID: String, passedUser: User, cateArr: [String]) async {
        
        var user = passedUser
        user.userID = userID
        
        let docData: [String: Any] = [
            DB_User.username: user.username,
            DB_User.email: user.email,
            DB_User.userID: user.userID,
            DB_User.dateSignedUp: user.dateSignedUp,
            DB_User.turnOnFiction: user.turnOnFiction,
            DB_User.start: user.start,
            DB_User.end: user.end,
            DB_User.howMany: user.howMany,
            DB_User.cateArr: cateArr,
            DB_User.histArr: User.mockData.histArr //empty
        ] //we can also use encodedUser method
        
        try? await Firestore.firestore().collection(DB_USER_COLL).document(user.userID).setData(docData)
        UserDefaults.standard.set(user.userID, forKey: currentUserDefaults.userID)
        
    }
    
    
    private func generateEmail() -> String {
        let randStr = randomString(length: 7)
        let randInt = Int.random(in: 1..<10000000)
        return "MAIL_\(randInt)_\(randStr)@gmail.com"
    }
    
}
