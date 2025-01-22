//
//  ForgotPassView.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/16/25.
//

import SwiftUI

struct ForgotPassView: View {
    
    @Environment(\.dismiss) var dismiss //back btn
    @State var showAlert: Bool = false
    @State var email: String = ""
    @State var message: String = ""
    
    var body: some View {
        VStack {
            //logo
            Image("wall1s")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle.circle)
                .padding(.all, 24)
                        
            TextField("Enter your Email", text: $email)
                .textInputAutocapitalization(.never)
                .modifier(TxtFieldModifier())
            
            Button {
                Task {
                    await AuthService.shared.sendResetPassEmail(email: email) { mess in
                        self.message = mess
                        showAlert.toggle()
                    }
                }
            } label: {
                ContBtnView(context: "Send Link")
                    .opacity(validEmail() ? 1 : 0.5)
            }
            .padding(.vertical)
            .disabled(!validEmail())
            
            Spacer()
        }
        .navigationTitle("Forgot Password?")
        .background(.white)
        .alert("Head's up!", isPresented: $showAlert) {
            Button("OK", role: .cancel, action: {
                if message == resetPassNote {
                    dismiss()
                }
            })
        } message: {
            Text(message)
        }
    }
    
    private func validEmail() -> Bool {
        return AuthService.shared.isValidEmail(email: email)
    }
}

#Preview {
    ForgotPassView()
}
