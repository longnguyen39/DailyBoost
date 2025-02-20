//
//  SettingScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//

import SwiftUI

struct SettingScreen: View {
        
    @Binding var user: User
    @Binding var showSetting: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 8) {
                    StreakSection()
                        .padding(.top, 12)
                    
                    SubscriptionSection(user: $user)
                    
                    AccountSection(user: $user)
                    
//                    SupportSection(user: $user) //later ver
                }
            }
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSetting.toggle()
                    } label: {
                        Image(systemName: "chevron.down")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                    }
//                    .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: showSetting)
                    
                }
            }
        }
    }
}

#Preview {
    SettingScreen(user: .constant(User.initState), showSetting: .constant(true))
}

//MARK: ---------------------------------------------

struct SettingRow: View {
    
    @Environment(\.colorScheme) var mode

    var imgName: String
    var context: String
        
    var body: some View {
        HStack {
            Image(systemName: imgName)
                .imageScale(.medium)
                .padding(.trailing, 8)
                .foregroundStyle(mode == .light ? .black : .white)
            
            Text(context)
                .font(.subheadline)
                .fontWeight(.regular)
                .foregroundStyle(mode == .light ? .black : .white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

//MARK: ------------------------------------------------

struct StreakSection: View {
    
    @Environment(\.colorScheme) var mode
    
    var body: some View {
        HStack {
            Text("Streak")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
            Spacer()
        }
        .padding(.horizontal)
        
        VStack {
            Text(streakTextMessage())
                .font(.subheadline)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .foregroundStyle(mode == .light ? .black : .white)
                .padding(.horizontal)
                .padding(.bottom, 4)
            
            StreakBar()
        }
        .padding()
        .background(mode == .light ? Color.white : DARK_GRAY)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding(.horizontal)
        .padding(.top, -12)
    }
    
}

//MARK: ------------------------------------------------

struct SubscriptionSection: View {
    
    @Environment(\.colorScheme) var mode
    @Binding var user: User
    
    var body: some View {
        HStack {
            Text("Subscription")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal)
        
        VStack {
            NavigationLink {
                Text("Paid features and subscriptions will be available in the next version.")
                    .font(.headline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                    .padding()
            } label: {
                SettingRow(imgName: "crown", context: "Manage subscription")
                    .padding(.top)
            }
        }
        .background(mode == .light ? Color.white : DARK_GRAY)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding(.horizontal)
    }
}

struct AccountSection: View {
    
    @Environment(\.colorScheme) var mode
    
    @Binding var user: User
        
    var body: some View {
        HStack {
            Text("Account")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal)
        
        VStack(spacing: 8) {
            NavigationLink {
                ProfileScreen(user: $user)
            } label: {
                SettingRow(imgName: "person", context: "Profile")
                    .padding(.top)
            }
            
            Divider()
                .padding(.horizontal)
                .padding(.top, -10)
            
            NavigationLink {
                LikeQuoteScreen(user: $user)
            } label: {
                SettingRow(imgName: "suit.heart", context: "Liked Quotes")
            }
            
            Divider()
                .padding(.horizontal)
                .padding(.top, -10)
            
            NavigationLink {
                ReminderScreen(user: $user)
            } label: {
                SettingRow(imgName: "bell", context: "Reminder")
            }
            
            Divider()
                .padding(.horizontal)
                .padding(.top, -10)
            
            NavigationLink {
                CateToggleScreen()
            } label: {
                SettingRow(imgName: "iphone.rear.camera", context: "Show Category")
            }
            
            //Widget for later version
//            Divider()
//                .padding(.horizontal)
//                .padding(.top, -10)
//            
//            NavigationLink {
//                WidgetInstructScreen()
//            } label: {
//                SettingRow(imgName: "widget.small", context: "Widget")
//            }
        }
        .background(mode == .light ? Color.white : DARK_GRAY)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay{
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding(.horizontal)
    }
}

struct SupportSection: View {
    
    @Binding var user: User
    
    var body: some View {
        HStack {
            Text("Support")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal)
        
        VStack {
            NavigationLink {
                ProfileScreen(user: $user)
            } label: {
                SettingRow(imgName: "camera.aperture", context: "Follow us on Instagram")
                    .padding(.top)
            }
            
            NavigationLink {
                ProfileScreen(user: $user)
            } label: {
                SettingRow(imgName: "hand.thumbsup", context: "Leave us a review")
                    .padding(.top, 8)
            }
            
            NavigationLink {
                ProfileScreen(user: $user)
            } label: {
                SettingRow(imgName: "square.and.arrow.up", context: "Share Daily Boost")
                    .padding(.top, 8)
            }
            
        }
        .overlay{
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding(.horizontal)
    }
}
