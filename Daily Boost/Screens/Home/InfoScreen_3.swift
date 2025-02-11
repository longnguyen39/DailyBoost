//
//  InfoScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//

import SwiftUI
import WebKit

struct InfoScreen: View {
    
    @Binding var showInfo: Bool
    @Binding var quoteInfo: Quote
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    showInfo.toggle()
                } label: {
                    Image(systemName: "chevron.down")
                        .imageScale(.large)
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                        .padding()
                }
                Spacer()
                
                Text("Author's info")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding()
            }
            .padding(.bottom, -4)
            
            WebView(urlStr: "https://www.google.com/search?q=\(authorStr())")
        }
    }
    
    private func authorStr() -> String {
        return quoteInfo.author.replacingOccurrences(of: " ", with: "+")
    }
}

#Preview {
    InfoScreen(showInfo: .constant(true), quoteInfo: .constant(Quote.mockQuote))
}

//MARK: ---------------------------------------------

struct WebView: UIViewRepresentable{
    
    var urlStr:String
    
    func makeUIView(context: Context) -> some UIView {
        guard let url = URL(string: urlStr) else {
            return WKWebView()
        }
        let webview = WKWebView()
        webview.load(URLRequest(url: url))
        return webview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
