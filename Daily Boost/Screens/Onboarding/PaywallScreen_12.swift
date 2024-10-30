//
//  PaywallScreen_12.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/8/24.
//

import SwiftUI

struct PaywallScreen: View {
    
    @EnvironmentObject var firstTime: FirstTime
    @Binding var user: User
    @Binding var pickedCateArr: [String]
    
    @State var showError: Bool = false
    @State var loading: Bool = false
    
    var body: some View {
        ZStack { //for LoadingView
            VStack {
                Text("Paywall")
                
                Spacer()
                
                Button {
                    Task {
                        try await createUser()
                    }
                    
                } label: {
                    ContBtnView(context: "Let's go")
                }
            }
            
            if loading {
                LoadingView()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert("Oops", isPresented: $showError) {
            Button("Try Again", role: .cancel, action: {})
        } message: {
            Text("There is something wrong, please exit the app and try again.")
        }
    }
    
//MARK: - Function
    
    private func createUser() async throws {
        loading = true
        var hasError = false
        try await AuthService.shared.createUser(passedUser: user, cateArr: pickedCateArr) { hasErr, err in
            if hasErr {
                print("DEBUG_12: err creating user \(err)")
                showError = hasErr
                hasError = hasErr
                loading = !hasErr
            }
        }
        try? await Task.sleep(nanoseconds: 0_100_000_000) //0.1s
        loading = false
        
        if !hasError {
            UserDefaults.standard.set(false, forKey: UserDe.first_time)
            firstTime.isFirstTime.toggle()
            print("DEBUG_12: user is \(user)")
        }
    }
    
    
}

#Preview {
    PaywallScreen(user: .constant(User.mockData), pickedCateArr: .constant(Quote.purposeStrArr))
}

//------------------------------------------------

class FirstTime: ObservableObject {
    @Published var isFirstTime: Bool = true
}
