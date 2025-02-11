//
//  QuoteUploadView.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/2/25.
//

import SwiftUI
import Firebase

struct QuoteUploadView: View {
    
    var quoteStr: String
    @State var initCount: Int = 0
    
    @State var didUpload: Bool = false
    @State var findDup: Bool = false
    
    var body: some View {
        HStack {
            Text("*  ")
            
            VStack(alignment: .leading) {
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
        initCount = await ServiceFetch.shared.fetchQuoteCount(title: quoteStr.getQTitle(), cate: quoteStr.getQCate(), isFiction: isUploadingFiction)
        initCount += isUploadingFiction ? 1000000 : 0
        
        //check duplicates
        let dupl = await checkDuplicatedQuote(title: quoteStr.getQTitle(), cate: quoteStr.getQCate(), script: quoteStr.getQScript())
        if dupl {
            print("DEBUG_16: found duplicates *** \(quoteStr)")
            findDup = true
            return
        }
        
        //configure quote and upload
        initCount += 1
        let quote = Quote(orderNo: initCount, script: quoteStr.getQScript(), title: quoteStr.getQTitle(), category: quoteStr.getQCate(), isFictional: isUploadingFiction, author: quoteStr.getQAuth())
        try await HelperUpload.shared.uploadCateTitle(quote: quote)
        try await HelperUpload.shared.uploadOneQuote(quote: quote)
        print("DEBUG_16: done uploading \(quote.orderNo)th quote for (\(quote.category))")
        didUpload = true
    }
    
    private func checkDuplicatedQuote(title: String, cate: String, script: String) async -> Bool {
        
        let snapshot = Firestore.firestore().collection(title).document(cate).collection(DB_CATETITLE_COLL).whereField("script", isEqualTo: script)
        
        do {
            let querySnapshot = try await snapshot.getDocuments()
            return !querySnapshot.documents.isEmpty //if no dupl found, return false
        } catch {
            print("DEBUG_14: error fetching duplicated script \(error.localizedDescription)")
            return true
        }
    }
}

#Preview {
    UploadScreen()
}

