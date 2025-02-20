//
//  StreakView.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/19/25.
//

import SwiftUI

extension HomeScreen {
    
    var StreakView: some View {
        VStack {
            Spacer()
            
            VStack {
                Text(streakTextMessage())
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .frame(height: 48)
                    .padding()
                    .padding(.top, 8)
                
                StreakBar()
                
                Button {
                    withAnimation {
                        vm.showStreak.toggle()
                    }
                } label: {
                    ThemeBtnView(context: streakBtnMessage())
                        .padding(.bottom, 32)
                        .padding(.top, 8)
                }
            }
            .frame(width: UIScreen.width, height: 240)
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(lineWidth: 0.5)
                    .foregroundStyle(Color(.systemGray4))
            }
            .background(mode == .light ? Color.white : Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .shadow(color: mode == .light ? .black.opacity(0.5) : Color.white.opacity(0.5), radius: 2)
    }
}

//MARK: - Func

extension HomeScreen {
    
    private func streakBtnMessage() -> String {
        let currentStreak = UserDefaults.standard.object(forKey: UserDe.currentStreak) as? Int ?? 1
        if currentStreak == 1 {
            return "I commit to 1 day"
        } else if currentStreak < 3 {
            return "I commit to 3 days"
        } else if currentStreak < 7 {
            return "I commit to 7 days"
        } else if currentStreak < 14 {
            return "I commit to 14 days"
        } else if currentStreak < 30 {
            return "I commit to 30 days"
        } else if currentStreak < 60 {
            return "I commit to 60 days"
        } else if currentStreak < 80 {
            return "I commit to 80 days"
        } else if currentStreak < 100 {
            return "I commit to 100 days"
        } else if currentStreak < 120 {
            return "I commit to 120 days"
        } else if currentStreak < 150 {
            return "I commit to 150 days"
        } else if currentStreak < 200 {
            return "I commit to 200 days"
        } else if currentStreak < 250 {
            return "I commit to 250 days"
        } else if currentStreak < 300 {
            return "I commit to 300 days"
        } else if currentStreak < 350 {
            return "I commit to 350 days"
        } else if currentStreak < 365 {
            return "I commit to 1 year"
        } else if currentStreak == 365 {
            return "Go for new year"
        } else {
            return "I commit to the next day"
        }
    }
}
