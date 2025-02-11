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
    var chosenCatePArr: [String]
    
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
                        ReminderTimeRow(time: $start, context: "Start at", didChange: $didChange)
                        ReminderTimeRow(time: $end, context: "End at", didChange: $didChange)
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
                            .opacity(didChange ? 1 : 0.4)
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
    
    private func saveChanges() async {
        showLoading = true
        try? await Task.sleep(nanoseconds: 0_100_000_000)
        user.howMany = howMany
        user.end = end
        user.start = start
        
        do {
            try await ServiceUpload.shared.updateUserReminder(user: user)
            await setNoti()
//            await setMockNoti()
            didChange = false
            showLoading = false
        } catch {
            print("DEBUG_ReminderScr: err updating reminder")
            showLoading = false
        }
    }
    
    private func setNoti() async {
        NotificationManager.shared.clearAllPendingNoti()
        
        var block = (end + 12 - start) * 60 / howMany
        block += (block / howMany) //based on testing
        
        for notiInt in 0..<howMany {
            if notiInt == howMany - 1 {
                await NotificationManager.shared.scheduleNoti(hour: end+12, min: 0, catePArr: chosenCatePArr)
            } else {
                let t = (start * 60) + (notiInt * block)
                let hour = t / 60
                let min = t % 60
                await NotificationManager.shared.scheduleNoti(hour: hour, min: min, catePArr: chosenCatePArr)
            }
        }
    }
    
    private func setMockNoti() async {
        NotificationManager.shared.clearAllPendingNoti()
        
        await NotificationManager.shared.scheduleNoti(hour: 0, min: 19, catePArr: chosenCatePArr)
    }
}

#Preview {
    ReminderScreen(user: .constant(User.initState), chosenCatePArr: [])
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
                    .foregroundStyle(howMany == 1 ? .gray : .blue)
            }
            .sensoryFeedback(.decrease, trigger: howMany)
            
            Text("\(howMany)x")
                .font(.system(size: 16))
                .fontWeight(.regular)
                .frame(width: 72)
                .padding(.horizontal, 12)
            
            Button {
                if howMany < 24 {
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
        }
        .padding(.horizontal, 4)
    }
}

struct ReminderTimeRow: View {
    
    @Binding var time: Int
    var context: String
    @Binding var didChange: Bool
    
    var body: some View {
        HStack {
            Text(context)
                .font(.system(size: 16))
                .fontWeight(.regular)
                .padding(.horizontal)
            
            Spacer()
            
            Button {
                if time > 0 {
                    time -= 1
                    didChange = true
                }
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.medium)
                    .fontWeight(.semibold)
                    .foregroundStyle(time == 0 ? .gray : .blue)
            }
            .sensoryFeedback(.increase, trigger: time)
            
            Text("\(time):00 \(timeFrame())")
                .font(.system(size: 16))
                .fontWeight(.regular)
                .frame(width: 72)
                .padding(.horizontal, 12)
            
            Button {
                if time < 11 {
                    time += 1
                    didChange = true
                }
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.medium)
                    .fontWeight(.semibold)
                    .foregroundStyle(time == 11 ? .gray : .blue)
                    .padding(.trailing)
            }
            .sensoryFeedback(.increase, trigger: time)
        }
        .padding(.horizontal, 4)
    }
    
    private func timeFrame() -> String {
        return context == "Start at" ? "AM" : "PM"
    }
}
