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
    
    var body: some View {
        VStack {
            ThemeImgView()
            
            Text("Set daily reminders")
                .font(.system(size: 24))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
                .padding(.horizontal)
                .padding(.top, -40)
            
            HowMany(widthFrame: timeWidthFrame, howMany: $user.howMany).padding()
            
            TimeView(widthFrame: timeWidthFrame, context: "Start at", time: $user.start).padding(.top, 12)
            TimeView(widthFrame: timeWidthFrame, context: "End at", time: $user.end).padding(.top, -4)
            
            Spacer()
            
            NavigationLink {
                WidgetScreen(user: $user, pickedCateArr: $pickedCateArr)
            } label: {
                ContBtnView(context: "Accept and Continue")
            }
        }
        .toolbar(.hidden, for: .navigationBar)
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
                .foregroundStyle(.black)
                .padding()
            
            Spacer()
            
            Button {
                howMany -= 1
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }
            
            Text("\(howMany)x")
                .font(.system(size: 18))
                .fontWeight(.regular)
                .foregroundStyle(.black)
                .frame(width: widthFrame)
                .padding(.horizontal, 12)
            
            Button {
                howMany += 1
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                    .padding(.trailing)
            }
        }
        .frame(width: UIScreen.width-48, height: 64)
        .background(.gray.opacity(0.4))
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
                .foregroundStyle(.black)
                .padding()
            
            Spacer()
            
            Button {
                time -= 1
            } label: {
                Image(systemName: "minus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }
            
            Text("\(time):00 \(timeFrame())")
                .font(.system(size: 18))
                .fontWeight(.regular)
                .foregroundStyle(.black)
                .frame(width: widthFrame)
                .padding(.horizontal, 12)
            
            Button {
                time += 1
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
                    .padding(.trailing)
            }
        }
        .frame(width: UIScreen.width-48, height: 64)
        .background(.gray.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
    
    private func timeFrame() -> String {
        return context == "Start at" ? "AM" : "PM"
    }
}
