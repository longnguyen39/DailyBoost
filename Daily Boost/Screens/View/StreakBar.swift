//
//  StreakBar.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/19/25.
//

import SwiftUI

struct StreakBar: View {
    
    @Environment(\.colorScheme) var mode
    let streakW: CGFloat = UIScreen.width - 64
    @AppStorage(UserDe.currentStreak) var streak: Int? //this on constantly pull data from userDefaults (if data from userDefaults change, it also changes live)
//    let streak = 78
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.gray.opacity(0.5))
                    .frame(width: streakW, height: 24)
                HStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .foregroundStyle(.color3)
                            .frame(width: 32, height: 32)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(mode == .light ? .black : .white)
                            }
                        Text("\(setGoalDays())")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundStyle(.white)
                    }
                }
            }
            .frame(width: streakW)
            
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(
                            LinearGradient(gradient: Gradient(colors: [.color3, .color4, .color5]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(height: 24)
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .foregroundStyle(.color3)
                                .frame(width: 32, height: 32)
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(mode == .light ? .black : .white)
                                }
                            Text("\(streak ?? 1)")
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundStyle(.white)
                        }
                        
                    }
                }
                .frame(width: setLength())
                
                Spacer()
            }
            .frame(width: streakW)
        }

    }
    
    private func setLength() -> CGFloat {
        let s = streak ?? 1
        let streakF = CGFloat(s)
        let goalDays = CGFloat(setGoalDays())
        var length = (streakF / goalDays) * streakW
        if length > streakW-40 {
            length = streakW-40
        }
        return length
    }
    
    private func setGoalDays() -> Int {
        let currentStreak = streak ?? 1
        
        if currentStreak == 1 {
            return 3
        } else if currentStreak < 3 {
            return 3
        } else if currentStreak < 7 {
            return 7
        } else if currentStreak < 14 {
            return 14
        } else if currentStreak < 30 {
            return 30
        } else if currentStreak < 60 {
            return 60
        } else if currentStreak < 80 {
            return 80
        } else if currentStreak < 100 {
            return 100
        } else if currentStreak < 120 {
            return 120
        } else if currentStreak < 150 {
            return 150
        } else if currentStreak < 200 {
            return 200
        } else if currentStreak < 250 {
            return 250
        } else if currentStreak < 300 {
            return 300
        } else if currentStreak < 350 {
            return 350
        } else if currentStreak < 365 {
            return 365
        } else if currentStreak == 365 {
            return 365
        } else {
            return 1
        }
    }
}

#Preview {
    StreakBar()
}
