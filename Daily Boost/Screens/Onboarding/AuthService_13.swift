//
//  AuthService.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/18/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

//we use "class" for AuthService
struct AuthService {
    
    static let shared = AuthService() //only 1 instance reused

    
//MARK: - Auth Function
//------------------------------------------------------
    
    @MainActor
    func logOutUser(completion: @escaping(_ success: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            print("DEBUG_13: just sign out")
            completion(true)
        } catch {
            print("DEBUG_13: error sign out \(error.localizedDescription)")
            completion(false)
            return
        }
        
        //deleting all UserDefaults
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let defaultDict = UserDefaults.standard.dictionaryRepresentation()
            defaultDict.keys.forEach { key in
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
    
    
    @MainActor //optional
    func login(withEmail email: String, password: String, completion: @escaping(String) -> Void) async {
        
        if await !checkEmailExistInDB(email: email) {
            completion("Your email is not found in our database. Please sign up first.")
            return
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            UserDefaults.standard.set(result.user.uid, forKey: currentUserDefaults.userID)
            completion("") //no err
        } catch {
            let e = error.localizedDescription
            print("DEBUG_13: login error \(e)")
            completion(e)
        }
    }
    
    @MainActor
    func sendResetPassEmail(email: String, completion: @escaping(String) -> Void) async {
        
        if await !checkEmailExistInDB(email: email) {
            completion("Your email is not found in our database. Please sign up first!")
            return
        }
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("DEBUG_13: done sending reset_pass link")
            completion(resetPassNote)
        } catch {
            let e = error.localizedDescription
            print("DEBUG_13: err sending reset p")
            completion(e)
        }
    }
    
    
    @MainActor //execute on the main thread (where most UI works)
    func createUser(user: User, cateArr: [String], completion: @escaping(Bool, String) -> Void) async {
        
        if await checkEmailExistInDB(email: user.email) {
            completion(true, "Your email already in our database. Please sign in.")
            return
        }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: user.email, password: "DailyBoost_\(user.email)")
            await self.uploadUserData(userID: result.user.uid, passedUser: user, cateArr: cateArr) //wait until the result is set, then func executes. Before Async/Await, we gotta use completion block
            print("DEBUG_13: just done upload userInfo")
            completion(false, "")
        } catch {
            let e = "\(error.localizedDescription) Please exit the app and try again."
            completion(true, e)
        }
        
    }
    
    //no need to delete user in Firestore
    func deleteAccount() async throws {
        let user = Auth.auth().currentUser
        try await user?.delete()
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
//MARK: - API Function
//------------------------------------------------------
    
    private func uploadUserData(userID: String, passedUser: User, cateArr: [String]) async {
        
        var user = passedUser
        user.userID = userID
        user.plan = "free"
        
        let docData: [String: Any] = [
            DB_User.username: user.username,
            DB_User.email: user.email,
            DB_User.userID: user.userID,
            DB_User.dateSignedUp: user.dateSignedUp,
            DB_User.fictionOption: user.fictionOption,
            DB_User.start: user.start,
            DB_User.end: user.end,
            DB_User.howMany: user.howMany,
            DB_User.cateArr: cateArr,
            DB_User.plan: user.plan,
            DB_User.histArr: User.mockData.histArr //empty
        ] //we can also use encodedUser method
        
        try? await Firestore.firestore().collection(DB_User.coll).document(userID).setData(docData)
        UserDefaults.standard.set(user.userID, forKey: currentUserDefaults.userID)
        
    }
    
    private func checkEmailExistInDB(email: String) async -> Bool {
        let snapshot = Firestore.firestore().collection(DB_User.coll).whereField("email", isEqualTo: email)
        do {
            let querySnapshot = try await snapshot.getDocuments()
            return !querySnapshot.documents.isEmpty
        } catch {
            print("DEBUG_13: err checking email in Firestore \(error.localizedDescription)")
            return true
        }
    }
    
}
