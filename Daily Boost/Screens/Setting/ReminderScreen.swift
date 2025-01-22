//
//  ReminderScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/19/25.
//

import SwiftUI

struct ReminderScreen: View {
    
    @Binding var user: User
    
    @State var didChange: Bool = false
    @State var showLoading: Bool = false
    
    @State var howMany: Int = 0
    @State var start: Int = 0
    @State var end: Int = 0
    
    var body: some View {
        ZStack {
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
                .padding(.horizontal)
                
                Divider()
                    .padding(.all, 8)
                    .padding(.top)
                
                Button {
                    Task {
                        await saveChanges()
                    }
                } label: {
                    ThemeBtnView(context: didChange ? "Save changes" : "Saved!", backC: didChange ? .yellow : .gray)
                        .fontWeight(.medium)
                        .opacity(didChange ? 1 : 0.5)
                }
                .disabled(!didChange)
                
                Spacer()
            }
            
            if showLoading {
                LoadingView()
            }
        }
        .navigationTitle("Reminder")
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
            didChange = false
            showLoading = false
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
                .foregroundStyle(.black)
                .padding(.horizontal)
            
            Spacer()
            
            Button {
                if howMany > 1 {
                    howMany -= 1
                    didChange = true
                }
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.medium)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }
            
            Text("\(howMany)x")
                .font(.system(size: 16))
                .fontWeight(.regular)
                .foregroundStyle(.black)
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
                    .foregroundStyle(.blue)
                    .padding(.trailing)
            }
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
                .foregroundStyle(.black)
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
                    .foregroundStyle(.blue)
            }
            
            Text("\(time):00 \(timeFrame())")
                .font(.system(size: 16))
                .fontWeight(.regular)
                .foregroundStyle(.black)
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
                    .foregroundStyle(.blue)
                    .padding(.trailing)
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func timeFrame() -> String {
        return context == "Start at" ? "AM" : "PM"
    }
}
