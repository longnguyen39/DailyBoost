//
//  CateAdjustScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/6/25.
//

import SwiftUI

struct CateAdjustScreen: View {
    
    @Binding var showCate: Bool
    @Binding var refetch: Bool
    @Binding var fictionPicked: FictionOption
    
    @State var notiGranted: Bool = false
    @Binding var user: User
    
    var body: some View {
        VStack {
            ScrollView {
                FictionSection(fictionPicked: $fictionPicked, isChanged: .constant(true))
                    .padding()
                    .padding(.bottom)
                
                ForEach(CateTitle.allCases, id: \.self) { order in
                    CateSection(caseOrder: order, chosenCatePathArr: $user.cateArr)
                }
            }
            
            Button {
                Task {
                    NotificationManager.shared.requestAuthorization { granted in
                        notiGranted = granted
                    }
                    await saveChanges()
                    if notiGranted {
                        await setAllNoti(user: user)
                    }
                }
            } label: {
                ThemeBtnView(context: "Show \(user.cateArr.count) categories")
                    .fontWeight(.medium)
                    .padding(.top, -8)
            }
        }
    }
    
//MARK: - Function
    
    private func saveChanges() async {
        print("DEBUG_28: cate chosen is \(user.cateArr.count)")
        
        //upload new arr to database
        UserDefaults.standard.set(fictionPicked.name, forKey: UserDe.fictionOption)
        await ServiceUpload.shared.updateCatePathArr(userID: user.userID, cateArr: user.cateArr)
        
        //refetch quoteArr in HomeScr
        refetch.toggle()
        showCate.toggle()
    }

}

