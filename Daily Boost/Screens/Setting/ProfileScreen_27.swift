//
//  ProfileScreen_27.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/6/25.
//

import SwiftUI

struct ProfileScreen: View {
    
    @Environment(\.colorScheme) var mode

    @Binding var user: User
    @State var showUpdateU: Bool = false
    
    @State var errMess: String = ""
    @State var showAlert: Bool = false
    
    @EnvironmentObject var firstTime: FirstTime
    @State var showConfirmLogout: Bool = false
    @State var showConfirmDelete: Bool = false
    @State var showLoading: Bool = false
        
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    CaptionView(context: "Account Information")
                        .padding(.top, 12)
                    
                    AccountRow(isUsername: false, context: "Email:", result: user.email).padding(.top, 4)
                    Divider()
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        .opacity(0.7)
                    
                    Button {
                        showUpdateU.toggle()
                    } label: {
                        AccountRow(isUsername: true, context: "Name:", result: user.username)
                    }

                    Divider()
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        .opacity(0.7)
                    
                    AccountRow(isUsername: false, context: "Joined:", result: getDate()).padding(.bottom)
                        
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 0.5)
                        .foregroundStyle(Color(.systemGray4))
                        .shadow(color: .black.opacity(0.4), radius: 2)
                }
                .background(mode == .light ? Color.white : Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
                .padding(.top, 8)
                
                Divider().padding(.all, 8)
                
                Button {
                    showConfirmLogout.toggle()
                } label: {
                    ThemeBtnView(context: "Logout", foreC: .white)
                        .fontWeight(.semibold)
                }
                .sensoryFeedback(.impact(weight: .heavy, intensity: 0.8), trigger: firstTime.isFirstTime)

                Button {
                    showConfirmDelete.toggle()
                } label: {
                    Text("Delete Account")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundStyle(.red)
                }
                .sensoryFeedback(.impact(weight: .heavy, intensity: 0.8), trigger: firstTime.isFirstTime)

            }
        } //scrollView
        .navigationTitle("Account")
        .alert("Username", isPresented: $showUpdateU) {
            TextField("Edit username", text: $user.username)
            Button("Cancel", role: .cancel, action: {})
            Button("Update", role: .destructive) {
                Task {
                    await updateUsername()
                }
            }
            .disabled(user.username.isEmpty)
        }
        .confirmationDialog("Logging out?", isPresented: $showConfirmLogout, titleVisibility: .visible, actions: {
            Button("Cancel", role: .cancel, action: {})
            Button("Logout", role: .destructive, action: {
                Task {
                    showLoading = true
                    try? await Task.sleep(nanoseconds: 0_100_000_000)
                    signOut()
                }
            })
        })
        .confirmationDialog("Delete This Account?", isPresented: $showConfirmDelete, titleVisibility: .visible, actions: {
            Button("Cancel", role: .cancel, action: {})
            Button("Delete Account", role: .destructive, action: {
                Task {
                    await deleteAcc()
                }
            })
        })
        .alert("Oops", isPresented: $showAlert) {
            Button("OK", role: .cancel, action: {})
        } message: {
            Text(errMess)
        }
    }
    
//MARK: - Function
    
    private func getDate() -> String {
        let date = user.dateSignedUp
        return "\(date.getMonthStr(.month)) \(date.get(.day)), \(date.get(.year))"
    }
    
    private func updateUsername() async {
        showLoading = true
        do {
            try await ServiceUpload.shared.updateUsername(userID: user.userID, username: user.username)
            showLoading = false
        } catch {
            showLoading = false
            print("DEBUG_27: err updating username \(error.localizedDescription)")
            errMess = "Error updating username. Please try again."
            showAlert.toggle()
        }
    }
    
    private func signOut() {
        AuthService.shared.logOutUser { success in
            clearThemeImage()
            showLoading = false

            if success {
                firstTime.isFirstTime.toggle()
                print("DEBUG_6: done signing out")
            } else {
                print("DEBUG_6: fail sign out")
                errMess = "There was an error signing out. Please exit the app and try again."
                showAlert.toggle()
            }
        }
    }
    
    private func clearThemeImage() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let p = UserDe.Local_ThemeImg
        let fileURL = documentsDirectory.appendingPathComponent(p)
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path) //remove old img
            } catch let err {
                print("DEBUG_27: cannot remove file at path", err.localizedDescription)
            }
        }
    }
    
    private func deleteAcc() async {
        showLoading = true
        try? await Task.sleep(nanoseconds: 0_100_000_000)
        
        do {
            try await AuthService.shared.deleteAccount()
            signOut()
        } catch {
            print("DEBUG_6: err delete acc")
            showLoading = false
            errMess = "Error deleting account. Please try again."
            showAlert.toggle()
        }
    }
}

#Preview {
    ProfileScreen(user: .constant(User.initState))
}

//--------------------------------------------------------

struct AccountRow: View {
    
    var isUsername: Bool
    var context: String
    var result: String
    
    var body: some View {
        HStack {
            Text(context)
                .font(.subheadline)
                .fontWeight(.regular)
                .frame(width: 64, alignment: .leading)
                .foregroundStyle(.gray)
            
            Text(result)
                .font(.subheadline)
                .fontWeight(.regular)
            
            Spacer()
            
            if isUsername {
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .fontWeight(.medium)
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 8)
            }
        }
        .padding(.horizontal)
    }
}

