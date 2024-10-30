//
//  UploadScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/30/24.
//

import SwiftUI

struct UploadScreen: View {
        
    var body: some View {
        VStack {
            ScrollView {
                ForEach(Quotes.quoteUploadArr, id: \.self) { quoteStr in
                    QuoteUploadView(quoteStr: quoteStr)
                }
            }
        }
        .onAppear {
            print("DEBUG_16: quoteUploadArr is \(Quotes.quoteUploadArr.count)")
            //check sources
        }
    }
    
    private func checkSources() {
        
    }
    
}

#Preview {
    UploadScreen()
}

//--------------------------------------------


struct QuoteUploadView: View {
    
    var quoteStr: String
    @State var initCount: Int = 0
    
    @State var didUpload: Bool = false
    @State var findDup: Bool = false
    
    var body: some View {
        HStack {
            Text("*  ")
            
            VStack {
                Text("\(quoteStr.getQScript())")
                    .multilineTextAlignment(.leading)
                HStack {
                    Spacer()
                    Text("\(quoteStr.getQAuth())")
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Spacer()
            
            Button {
                if !didUpload {
                    Task {
                        do {
                            try await configureAndUploadQuote()
                        } catch {
                            print("DEBUG_16: err \(error.localizedDescription)")
                        }
                    }
                }
            } label: {
                Image(systemName: didUpload ? "checkmark.circle.fill" : "square.and.arrow.up")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding()
            }
            
        }
        .padding()
        .background(configureStatusColor())
    }
    
//MARK: - Functions
    
    private func configureStatusColor() -> Color {
        if didUpload {
            return .green
        } else {
            return findDup ? .gray : .clear
        }
    }
    
    private func configureAndUploadQuote() async throws {
        initCount = await ServiceFetch.shared.fetchQuoteCount(title: quoteStr.getQTitle(), cate: quoteStr.getQCate())
        
        //check duplicates
        let dupl = try await ServiceFetch.shared.checkDuplicatedQuote(title: quoteStr.getQTitle(), cate: quoteStr.getQCate(), script: quoteStr.getQScript())
        if dupl {
            print("DEBUG_16: found duplicates *** \(quoteStr)")
            findDup = true
            return
        }
        
        //configure quote and upload
        initCount += 1
        let quote = Quote(orderNo: initCount, script: quoteStr.getQScript(), title: quoteStr.getQTitle(), category: quoteStr.getQCate(), isFictional: false, author: quoteStr.getQAuth())
        try await HelperUploadQuotes.share.uploadCateTitle(quote: quote)
        try await HelperUploadQuotes.share.uploadOneQuote(quote: quote)
        print("DEBUG_16: done uploading \(quote.orderNo)th quote for (\(quote.category))")
        didUpload = true
    }
    
}
