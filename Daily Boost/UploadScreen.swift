//
//  UploadScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/30/24.
//

import SwiftUI

public var isUploadingFiction = false

struct UploadScreen: View {
    
    @State var showReport: Bool = false
        
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    NavigationLink {
                        QuoteReportScreen(isFiction: true)
                    } label: {
                        ContBtnView(context: "Fictional Quote")
                    }
                    
                    NavigationLink {
                        QuoteReportScreen(isFiction: false)
                    } label: {
                        ContBtnView(context: "Non-fictional Quote")
                    }
                    
                    NavigationLink {
                        ThemeUploadScreen()
                    } label: {
                        ContBtnView(context: "Theme upload")
                    }
                    
                    Divider().padding()
                    
                    ForEach(Quotes.quoteUploadArr, id: \.self) { quoteStr in
                        QuoteUploadView(quoteStr: quoteStr)
                    }
                }
            }
            .navigationTitle("Upload Quotes")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Quotes.getFictionOrNot()
                print("DEBUG_UploadScr: there are \(isUploadingFiction ? "fictional" :  "Non-fictional") \(Quotes.quoteUploadArr.count) quotes to upload")
            }
        }
    }
    
}

#Preview {
    UploadScreen()
}
