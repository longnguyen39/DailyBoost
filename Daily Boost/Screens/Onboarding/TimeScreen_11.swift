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
            
            TimeView(widthFrame: timeWidthFrame, context: "Start at", time: $user.start).padding(.top, 12)
            TimeView(widthFrame: timeWidthFrame, context: "End at", time: $user.end).padding(.top, -4)
            
            Spacer()
            
            ZStack {
                if notiGranted {
                    NavigationLink {
                        WidgetScreen(
                            notiGranted: message == "You have allowed notification!",
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

struct TimeView: View {
    
    var widthFrame: CGFloat
    var context: String
    @Binding var time: Int
    
    var body: some View {
        HStack {
            Text(context)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .padding()
            
            Spacer()
            
            Button {
                if time > 0 {
                    time -= 1
                }
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(time == 0 ? .gray : .blue)
            }
            
            Text("\(time):00 \(timeFrame())")
                .font(.system(size: 18))
                .fontWeight(.regular)
                .frame(width: widthFrame)
                .padding(.horizontal, 12)
            
            Button {
                if time < 11 {
                    time += 1
                }
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(time == 11 ? .gray : .blue)
                    .padding(.trailing)
            }
        }
        .frame(width: UIScreen.width-48, height: 64)
        .background(DARK_GRAY)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
    
    private func timeFrame() -> String {
        return context == "Start at" ? "AM" : "PM"
    }
}
