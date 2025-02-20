//
//  ReminderScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/19/25.
//

import SwiftUI

struct ReminderScreen: View {
    
    @Environment(\.colorScheme) var mode
    @Environment(\.presentationMode) var back //go back nav
    
    @State var notiGranted: Bool = false
    
    @Binding var user: User
    
    @State var didChange: Bool = false
    @State var showLoading: Bool = false
    
    @State var howMany: Int = 0
    @State var start: Int = 0
    @State var end: Int = 0
    
    var body: some View {
        ZStack {
            if notiGranted {
                VStack {
                    CaptionView(context: "Manage your Daily Reminder.")
                        .padding(.top)
                        .padding(.bottom, 8)
                    
                    VStack(spacing: 24) {
                        ReminderHowManyRow(howMany: $howMany, didChange: $didChange)
                            .padding(.top)
                        ReminderStartTimeRow(start: $start, end: $end, didChange: $didChange)
                        ReminderEndTimeRow(start: $start, end: $end, didChange: $didChange)

                            .padding(.bottom)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 0.5)
                            .foregroundStyle(Color(.systemGray4))
                            .shadow(color: .black.opacity(0.4), radius: 2)
                    }
                    .background(mode == .light ? Color.white : Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.all, 8)
                        .padding(.top)
                    
                    Button {
                        Task {
                            await saveChanges()
                        }
                    } label: {
                        ThemeBtnView(context: didChange ? "Save changes" : "Saved!")
                            .fontWeight(.medium)
                            .opacity(didChange ? 1 : 0.6)
                    }
                    .disabled(!didChange)
                    
                    Spacer()
                }
            } else {
                VStack {
                    CaptionView(context: "Please enable notification so you can receive Daily Boost Quotes every day.")
                        .padding()
                    
                    Button {
                        //go to setting
                        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                            if UIApplication.shared.canOpenURL(appSettings) {
                                
                                UIApplication.shared.open(appSettings)
                                self.back.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        ThemeBtnView(context: "Enable Notification")
                            .fontWeight(.medium)
                    }
                    Spacer()
                }
                .onAppear {
                    NotificationManager.shared.requestAuthorization { granted in
                        notiGranted = granted
                    }
                }
            }
            
            if showLoading {
                LoadingView()
            }
        }
        .navigationTitle("Reminder")
        .sensoryFeedback(.success, trigger: showLoading)
        .onAppear { //we change User only when user saves change
            howMany = user.howMany
            start = user.start
            end = user.end
        }
    }

//MARK: - Function
    
    private func saveChanges() async {
        showLoading = true
        try? await Task.sleep(nanoseconds: 0_100_000_000)
        user.howMany = howMany
        user.end = end
        user.start = start
        
        //set noti + update DB
        do {
            try await ServiceUpload.shared.updateUserReminder(user: user)
            didChange = false
            showLoading = false
            await setAllNoti(user: user)
        } catch {
            print("DEBUG_ReminderScr: err updating reminder")
            showLoading = false
        }
    }
    
}

#Preview {
    ReminderScreen(user: .constant(User.initState))
}

//----------------------------------------------------

struct ReminderHowManyRow: View {
    
    @Binding var howMany: Int
    @Binding var didChange: Bool
    
    var body: some View {
        HStack {
            Text("How many")
                .font(.system(size: 16))
                .fontWeight(.regular)
                .padding(.horizontal)
            
            Spacer()
            
            Button {
                if howMany > 2 {
                    howMany -= 1
                    didChange = true
                }
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.medium)
                    .fontWeight(.semibold)
                    .foregroundStyle(howMany == 2 ? .gray : .blue)
            }
            .sensoryFeedback(.decrease, trigger: howMany)
            .disabled(howMany == 2)
            
            Text("\(howMany)x")
                .font(.system(size: 16))
                .fontWeight(.regular)
                .frame(width: 72)
                .padding(.horizontal, 12)
            
            Button {
                if howMany < 16 {
                    howMany += 1
                    didChange = true
                }
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.medium)
                    .fontWeight(.semibold)
                    .foregroundStyle(howMany == 24 ? .gray : .blue)
                    .padding(.trailing)
            }
            .sensoryFeedback(.increase, trigger: howMany)
            .disabled(howMany == 24)
        }
        .padding(.horizontal, 4)
    }
}

//----------------------------------------------------

struct ReminderStartTimeRow: View {
    
    @Binding var start: Int
    @Binding var end: Int //in minute
    @Binding var didChange: Bool
    
    var body: some View {
        HStack {
            Text("Start at")
                .font(.system(size: 16))
                .fontWeight(.regular)
                .padding(.horizontal)
            
            Spacer()
            
            Button {
                if validMinus() {
                    start -= TimeDecree
                    didChange = true
                }
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.medium)
                    .fontWeight(.semibold)
                    .foregroundStyle(start >= TimeDecree ? .blue : .gray)
            }
            .disabled(!validMinus())
            .sensoryFeedback(.increase, trigger: start)
            
            Text(displayTime())
                .font(.system(size: 16))
                .fontWeight(.regular)
                .frame(width: 72)
                .padding(.horizontal, 12)
            
            Button {
                if validPlus() {
                    start += TimeDecree
                    didChange = true
                }
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.medium)
                    .fontWeight(.semibold)
                    .foregroundStyle(start < 86400 - TimeDecree ? .blue : .gray)
                    .padding(.trailing)
            }
            .disabled(!validPlus())
            .sensoryFeedback(.increase, trigger: start)
        }
        .padding(.horizontal, 4)
    }
    
    private func displayTime() -> String {
        let hour = start / 3600
        let min = (start % 3600) / 60
        let minStr = min < 10 ? "0\(min)" : "\(min)"
        
        if hour < 12 {
            return "\(hour):\(minStr) AM"
        } else {
            if hour-12 == 0 {
                return "12:\(minStr) PM"
            } else {
                return "\(hour-12):\(minStr) PM"
            }
        }
    }
    
    private func validPlus() -> Bool {
        return start < end - TimeDecree
    }
    
    private func validMinus() -> Bool {
        return start >= TimeDecree
    }
    
}

struct ReminderEndTimeRow: View {
    
    @Binding var start: Int
    @Binding var end: Int
    @Binding var didChange: Bool
    
    var body: some View {
        HStack {
            Text("End at")
                .font(.system(size: 16))
                .fontWeight(.regular)
                .padding(.horizontal)
            
            Spacer()
            
            Button {
                if validMinus() {
                    end -= TimeDecree
                    didChange = true
                }
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.medium)
                    .fontWeight(.semibold)
                    .foregroundStyle(validMinus() ? .blue : .gray)
            }
            .disabled(!validMinus())
            .sensoryFeedback(.increase, trigger: end)
            
            Text(displayTime())
                .font(.system(size: 16))
                .fontWeight(.regular)
                .frame(width: 72)
                .padding(.horizontal, 12)
            
            Button {
                if validPlus() {
                    end += TimeDecree
                    didChange = true
                }
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.medium)
                    .fontWeight(.semibold)
                    .foregroundStyle(validPlus() ? .blue : .gray)
                    .padding(.trailing)
            }
            .disabled(!validPlus())
            .sensoryFeedback(.increase, trigger: end)
        }
        .padding(.horizontal, 4)
    }
    
    private func displayTime() -> String {
        let hour = end / 3600
        let min = (end % 3600) / 60
        let minStr = min < 10 ? "0\(min)" : "\(min)"
        
        if hour < 12 {
            return "\(hour):\(minStr) AM"
        } else {
            if hour-12 == 0 {
                return "12:\(minStr) PM"
            } else {
                return "\(hour-12):\(minStr) PM"
            }
        }
    }
    
    private func validPlus() -> Bool {
        return end < 86400 - TimeDecree
    }
    
    private func validMinus() -> Bool {
        return start < end - TimeDecree
    }
    
}
