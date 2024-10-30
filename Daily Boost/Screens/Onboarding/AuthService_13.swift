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
class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User? //for fetching user info
    
    static let shared = AuthService() //only 1 instance reused
        
    //this init keeps user logged in
    init() {
        Task {
//            try await loadUserData()
        }
    }
    
    
//MARK: - Auth Function
//------------------------------------------------------
    
    @MainActor //use completion to handle error alert display
    func createUser(email: String, password: String, username: String, completion: @escaping(Bool, String) -> Void) async throws {
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) //with async await, the result wait for func Auth.createUser to complete then set its value
            self.userSession = result.user
            
            //upload userInfo to Firebase
            await self.uploadUserData(uid: result.user.uid, username: username, email: email, pass: password) //populate @Published var currentUser
            
            print("DEBUG: done create new user")
        } catch {
            let e = error.localizedDescription
            print("DEBUG: createUser error \(e)")
            completion(true, e)
        }
        
    }
}
