//
//  SettingScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//

import SwiftUI

struct SettingScreen: View {
    
    @Binding var showSetting: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    SettingSection(title: "Profile")
                    SettingSection(title: "Quotes")
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

                }
            }
        }
        
    }
}

#Preview {
    SettingScreen(showSetting: .constant(true))
}

//MARK: ---------------------------------------------

struct SettingSection: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.regular)
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal)
        
        VStack {
            SettingRow()
                .padding(.top)
            SettingRow()
            SettingRow()
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

struct SettingRow: View {
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .imageScale(.medium)
            
            Text("Profile")
                .font(.subheadline)
                .fontWeight(.regular)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}
