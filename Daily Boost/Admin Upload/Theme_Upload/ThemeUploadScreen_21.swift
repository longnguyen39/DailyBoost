//
//  ThemeUploadScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 11/6/24.
//

import SwiftUI
import Firebase

let themeTitleGlobal = ThemeWallpaper.plain.name
var imgNameGlobal = "" //for PreviewThemeScreen

struct ThemeUploadScreen: View {
    
    @State var showPreviewTheme: Bool = false
    @State var isDarkText: String = "false"
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(39...58, id: \.self) { imgInt in
                    ThemeHView(showPreviewScreen: $showPreviewTheme, themeImg: "theme\(imgInt)", isDarkText: $isDarkText)
                }
            }
        }
        .fullScreenCover(isPresented: $showPreviewTheme) {
            PreviewThemeScreen(showPreviewScreen: $showPreviewTheme, isDarkText: $isDarkText, imgName: imgNameGlobal)
        }
        
    }
}

#Preview {
    ThemeUploadScreen()
}

//-----------------------------------------

struct ThemeHView: View {
    
    @Binding var showPreviewScreen: Bool
    var themeImg: String
    @Binding var isDarkText: String
    
    @State var didUpload: Bool = false
    
    var body: some View {
        HStack {
            ZStack {
                Image(themeImg)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 112, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .onTapGesture {
                        imgNameGlobal = themeImg //to present pict in showPreviewScreen
                        showPreviewScreen.toggle()
                    }
                
                Text("abcd")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(isDarkText == "false" ? .white : .black)
            }
            
            Spacer()
            
            Button {
                if !didUpload {
                    uploadThemeImage()
                } else {
                    print("DEBUG_21: already uploaded")
                }
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding()
            }

        }
        .background(didUpload ? Color.green : Color.clear)
    }
    
//MARK: Function
    
    //convert a view (in this case, the image) to uiImage
    //if we just simply convert an Image to uiImage, the uiImage upload is weird and not look like what we see on screen b4 uploading
    private func uploadThemeImage() {
        let image: Image = Image(themeImg)
        let renderer = ImageRenderer(content: image)
        
        if let uiImage = renderer.uiImage {
            ThemeManager.shared.uploadThemeImage(theme: Theme(fileName: "", isDarkText: isDarkText, title: themeTitleGlobal), image: uiImage) { success in
                if success {
                    print("DEBUG_21: all done upload img and theme data")
                    didUpload = true
                } else {
                    print("DEBUG_21: err uploading theme")
                }
            }
        }
    }
    
}
