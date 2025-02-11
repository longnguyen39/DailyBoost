//
//  SettingScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//

import SwiftUI

struct SettingScreen: View {
    
    //only for ReminderScr
    var chosenCatePArr: [String]
    
    @Binding var user: User
    @Binding var showSetting: Bool
    @Binding var showCateTopLeft: Bool
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 8) {
                    ToggleSection(showCateTopLeft: $showCateTopLeft)
                        .padding(.top)
                    
                    SubscriptionSection(user: $user)
                    
                    AccountSection(user: $user, chosenCatePArr: chosenCatePArr)
                    
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
    SettingScreen(chosenCatePArr: [], user: .constant(User.initState), showSetting: .constant(true), showCateTopLeft: .constant(true))
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

struct ToggleSection: View {
    
    @Environment(\.colorScheme) var mode
    @Binding var showCateTopLeft: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("*Display the quote category on top left corner")
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Toggle("Show Category", isOn: $showCateTopLeft)
                .tint(.color3)
                .fontWeight(.medium)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .background(mode == .light ? Color.white : DARK_GRAY)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
        .onChange(of: showCateTopLeft) {
            UserDefaults.standard.set(showCateTopLeft, forKey: UserDe.show_top_left)
        }
        .sensoryFeedback(.selection, trigger: showCateTopLeft)
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
    var chosenCatePArr: [String]
        
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
                ReminderScreen(user: $user, chosenCatePArr: chosenCatePArr)
            } label: {
                SettingRow(imgName: "bell", context: "Reminder")
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
