//
//  EmailScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/12/25.
//

import SwiftUI

struct EmailScreen: View {
    
    @Environment(\.colorScheme) var mode

    @FocusState private var keyboardFocused: Bool //keyboard popup

    @Binding var user: User
    @Binding var pickedCateArr: [String]
    
    //below is Min-Vi-Prodict version
    @EnvironmentObject var firstTime: FirstTime
    @State var showError: Bool = false
    @State var showLoading: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            VStack {
//                Text("What's your email?")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .padding(.top, 24)
                
                Text("We need your email to back up your data")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .padding(.top, 12)
                
                //userInput is store in viewModel.email
                TextField("Enter your email", text: $user.email)
                    .textInputAutocapitalization(.never)
                    .modifier(TxtFieldModifier())
                    .focused($keyboardFocused)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            keyboardFocused = true
                        }
                    }
                
                Button {
                    Task {
                        try await createUser()
                    }
                } label: {
                    ContBtnView(context: "Let's go!")
                        .opacity(validEmail() ? 1 : 0.4)
                }
                .padding(.vertical)
                .disabled(!validEmail())
                
                NavigationLink {
                    LoginScreen()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?  - ")
                            .fontWeight(.regular)
                            .foregroundStyle(mode == .light ? .black : .white)
                        Text(" Login")
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                    .font(.subheadline)
                }
                
//the btn above is MVP version
    //            NavigationLink(destination: {
    //                PaywallScreen(user: $user, pickedCateArr: $pickedCateArr)
    //            }, label: {
    //                ContBtnView(context: "Next")
    //                    .opacity(user.email.isEmpty ? 0.5 : 1)
    //            })
    //            .padding(.vertical)
    //            .disabled(user.email.isEmpty)
                
                Spacer()
            }
            
            if showLoading {
                LoadingView()
            }
        }
        .navigationTitle("Email")
        .alert("Oops", isPresented: $showError) {
            Button("Try Again", role: .cancel, action: {})
        } message: {
            Text("\(errorMessage)")
        }
    }
    
//MARK: - Function
    
    private func validEmail() -> Bool {
        return AuthService.shared.isValidEmail(email: user.email)
    }
    
    private func createUser() async throws {
        showLoading = true
        var hasError = false
        
        await AuthService.shared.createUser(user: user, cateArr: pickedCateArr) { hasErr, err in
            errorMessage = err
            if hasErr {
                print("DEBUG_12: err creating user \(err)")
                showError = hasErr
                hasError = hasErr
                showLoading = !hasErr
            }
        }
        try? await Task.sleep(nanoseconds: 0_100_000_000) //0.1s
        showLoading = false
        
        if !hasError {
            UserDefaults.standard.set(false, forKey: UserDe.first_time)
            UserDefaults.standard.set(FictionOption.both.name, forKey: UserDe.fictionOption)
            
            firstTime.isFirstTime.toggle()
            print("DEBUG_12: user is \(user.email)")
        }
    }
}

#Preview {
    EmailScreen(user: .constant(User.mockData), pickedCateArr: .constant(Quote.purposeStrArr))
}

//MARK: ---------------------------------------------------

struct TxtFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
    }
}
