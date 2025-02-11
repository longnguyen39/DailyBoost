//
//  CateAdjustScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/6/25.
//

import SwiftUI

struct CateAdjustScreen: View {
    
    @AppStorage(currentUserDefaults.userID) var userID: String? //this on constantly pull data from userDefaults (if data from userDefaults change, it also changes live)
    @Binding var showCate: Bool

    @Binding var chosenCatePathArr: [String]
    @Binding var refetch: Bool
        
    @Binding var fictionPicked: FictionOption
    
    var body: some View {
        VStack {
            ScrollView {
                FictionSection(fictionPicked: $fictionPicked, isChanged: .constant(true))
                    .padding()
                    .padding(.bottom)
                
                ForEach(CateTitle.allCases, id: \.self) { order in
                    CateSection(
                        caseOrder: order,
                        chosenCatePathArr: $chosenCatePathArr
                        )
                }
            }
            
            Button {
                Task {
                    await saveChanges()
                }
            } label: {
                ThemeBtnView(context: "Show \(chosenCatePathArr.count) categories")
                    .fontWeight(.medium)
                    .padding(.top, -8)
            }
        }
    }
    
//MARK: - Function
    
    private func saveChanges() async {
        print("DEBUG_28: cate chosen is \(chosenCatePathArr.count)")
        
        //upload new arr to database
        UserDefaults.standard.set(fictionPicked.name, forKey: UserDe.fictionOption)
        await ServiceUpload.shared.updateCatePathArr(userID: userID ?? "nil", cateArr: chosenCatePathArr)
        
        //refetch quoteArr in HomeScr
        refetch.toggle()
        showCate.toggle()
    }

}

