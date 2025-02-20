//
//  TimeScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 6/27/24.
//

import SwiftUI


struct TimeScreen: View {
    
    @Binding var user: User
    @Binding var pickedCateArr: [String]
    var timeWidthFrame: CGFloat = 80
    
    @State var notiGranted: Bool = false
    @State var showAlert: Bool = false
    @State var message: String = ""
    
    var body: some View {
        VStack {
            ThemeImgView()
            
            Text("Set daily reminders")
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, -40)
            
            HowMany(widthFrame: timeWidthFrame, howMany: $user.howMany).padding()
            
            TimeStartView(widthFrame: timeWidthFrame, start: $user.start, end: $user.end).padding(.top, 12)
            TimeEndView(widthFrame: timeWidthFrame, start: $user.start, end: $user.end).padding(.top, -4)
            
            Spacer()
            
            ZStack {
                if notiGranted {
                    NavigationLink {
                        WidgetScreen(
                            user: $user,
                            pickedCateArr: $pickedCateArr)
                    } label: {
                        ContBtnView(context: "Continue")
                    }
                } else {
                    Button {
                        NotificationManager.shared.requestAuthorization { granted in
                            if granted {
                                message = "You have allowed notification!"
                            } else {
                                message = "Please enable notification in your Setting"
                            }
                            showAlert.toggle()
                        }
                    } label: {
                        ContBtnView(context: "Allow Notifications")
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert("Hey", isPresented: $showAlert) {
            Button("OK", role: .cancel, action: {
                notiGranted.toggle()
            })
        } message: {
            Text("\(message)")
        }
    }
    
}

#Preview {
    TimeScreen(user: .constant(User.mockData), pickedCateArr: .constant(Quote.purposeStrArr))
}


//------------------------------------------------

struct HowMany: View {
    
    var widthFrame: CGFloat
    @Binding var howMany: Int
    
    var body: some View {
        HStack {
            Text("How many")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .padding()
            
            Spacer()
            
            Button {
                if howMany > 2 {
                    howMany -= 1
                }
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }
            
            Text("\(howMany)x")
                .font(.system(size: 18))
                .fontWeight(.regular)
                .frame(width: widthFrame)
                .padding(.horizontal, 12)
            
            Button {
                if howMany < 24 {
                    howMany += 1
                }
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(howMany == 24 ? .gray : .blue)
                    .padding(.trailing)
            }
        }
        .frame(width: UIScreen.width-48, height: 64)
        .background(DARK_GRAY)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct TimeStartView: View {
    
    var widthFrame: CGFloat
    @Binding var start: Int
    @Binding var end: Int
    
    var body: some View {
        HStack {
            Text("Start at")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .padding()
            
            Spacer()
            
            Button {
                if validMinus() {
                    start -= TimeDecree
                }
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(start >= TimeDecree ? .blue : .gray)
            }
            .disabled(!validMinus())
            .sensoryFeedback(.increase, trigger: start)
            
            Text(displayTime())
                .font(.system(size: 18))
                .fontWeight(.regular)
                .frame(width: widthFrame)
                .padding(.horizontal, 12)
            
            Button {
                if validPlus() {
                    start += TimeDecree
                }
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(start < 86400 - TimeDecree ? .blue : .gray)
                    .padding(.trailing)
            }
            .disabled(!validPlus())
            .sensoryFeedback(.increase, trigger: start)
        }
        .frame(width: UIScreen.width-48, height: 64)
        .background(DARK_GRAY)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
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

struct TimeEndView: View {
    
    var widthFrame: CGFloat
    @Binding var start: Int
    @Binding var end: Int
    
    var body: some View {
        HStack {
            Text("End at")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .padding()
            
            Spacer()
            
            Button {
                if validMinus() {
                    end -= TimeDecree
                }
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }
            .disabled(!validMinus())
            .sensoryFeedback(.increase, trigger: end)
            
            Text(displayTime())
                .font(.system(size: 18))
                .fontWeight(.regular)
                .frame(width: widthFrame)
                .padding(.horizontal, 12)
            
            Button {
                if validPlus() {
                    end += TimeDecree
                }
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                    .padding(.trailing)
            }
            .disabled(!validPlus())
            .sensoryFeedback(.increase, trigger: end)
        }
        .frame(width: UIScreen.width-48, height: 64)
        .background(DARK_GRAY)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
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
