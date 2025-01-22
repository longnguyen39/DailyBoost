//
//  LoginScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/12/25.
//

import SwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject var firstTime: FirstTime
    @State var showError: Bool = false
    @State var showLoading: Bool = false
    @State var errorMessage: String = ""
    
    @FocusState var showKeyboard: Bool
    
    @State var email: String = ""
    @State var passw: String = ""
    
    var body: some View {
        ZStack { //loadingView
            VStack {
                Image("wall1s")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(.circle)
                //                        .overlay(content: {
                //                            RoundedRectangle(cornerRadius: 20).stroke(.pink, lineWidth: 3)
                //                        })
                    .padding(.all, 24)
                
                //textField
                VStack(spacing: 16) {
                    TextField("Enter your Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .modifier(TxtFieldModifier())
                        .disableAutocorrection(true)
                        .keyboardType(.alphabet)
                    
                    SecureField("Enter your Password", text: $passw)
                        .textInputAutocapitalization(.never)
                        .modifier(TxtFieldModifier())
                        .keyboardType(.alphabet)
                }
                .focused($showKeyboard)
                .submitLabel(.continue)
                .disableAutocorrection(true)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Dismiss") {
                            showKeyboard = false
                        }
                    }
                }
                
                NavigationLink {
                    ForgotPassView()
                } label: {
                    Text("Forgot password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.pink)
                        .padding(.top)
                        .padding(.trailing, 28)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                //Login Btn
                Button {
                    Task {
                        await logIn()
                    }
                } label: {
                    ContBtnView(context: "Let's go!")
                        .opacity(email.isEmpty ? 0.5 : 1)
                }
                .padding(.vertical)
                
                Spacer()
            }
            .alert("Oops", isPresented: $showError) {
                Button("Try Again", role: .cancel, action: {})
            } message: {
                Text(errorMessage)
            }
            
            if showLoading {
                LoadingView()
            }
        }
        .navigationTitle("Login")
        .background(.white)
    }
    
    private func logIn() async {
        showKeyboard = false
        showLoading = true
        
        try? await Task.sleep(nanoseconds: 0_100_000_000) //0.1s
        
        await AuthService.shared.login(withEmail: email, password: passw) { err in
            showLoading = false
            
            if !err.isEmpty {
                print("DEBUG_12: err creating user \(err)")
                errorMessage = err
                showError.toggle()
                return
            }
            
            //proceed when login succeeds
            UserDefaults.standard.set(false, forKey: UserDe.first_time)
            UserDefaults.standard.set(FictionOption.both.name, forKey: UserDe.fictionOption)
            
            firstTime.isFirstTime.toggle()
            print("DEBUG_26: just login \(email)")
        }
    }
}

#Preview {
    LoginScreen()
}
