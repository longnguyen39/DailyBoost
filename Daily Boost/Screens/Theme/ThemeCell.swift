//
//  ThemeCell.swift
//  Daily Boost
//
//  Created by Long Nguyen on 11/4/24.
//

import SwiftUI

let themeCellW: CGFloat = (UIScreen.width - 64) / 3
let themeCellH: CGFloat = themeCellW * 1.8

struct ThemeCell: View {
    
    @Environment(\.colorScheme) var mode
    
    @AppStorage(UserDe.isDarkText) var isDarkText: Bool?
    @AppStorage(UserDe.themeFileName) var fileName: String?
    
    @Binding var showTheme: Bool
    @State var isPicked: Bool = false
    @State var theme: Theme
    
    @State var themeUIImage: UIImage = UIImage(named: "loading")!
    
    var body: some View {
        ZStack {
            Image(uiImage: themeUIImage)
                .resizable()
                .scaledToFill()
                .frame(width: themeCellW, height: themeCellH)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(configBorderC())
                }
                .onTapGesture {
                    chooseThemeImg()
                }
            
            Text("abcd")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(configTextColor())
                .onTapGesture {
                    chooseThemeImg()
                }
            
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.medium)
                        .foregroundStyle(isPicked ? .color3 : .clear)
                        .background(isPicked ? .white : .clear)
                        .clipShape(.circle)
                        .padding(.all, 8)
                }
                Spacer()
            }
        }
        .sensoryFeedback(.success, trigger: theme)
        .onAppear {
            if isPicked { //for fist cell appear on top
                themeUIImage = loadThemeImgFromDisk(path: UserDe.Local_ThemeImg)
            } else {
                fetchThemeImg()
            }
        }
    }
    
//MARK: - Function
    
    private func configBorderC() -> Color {
        if mode == .light {
            return isPicked ? .black : .clear
        } else {
            return isPicked ? .white : .clear
        }
    }
    
    func configTextColor() -> Color {
        if isPicked {
            return isDarkText ?? false ? .black : .white
        } else {
            return theme.isDarkText == "true" ? .black : .white
        }
    }
    
    func fetchThemeImg() {
        let file = fileName ?? ""
        if file.isEmpty && theme.fileName == "default" {
            isPicked = true
            themeUIImage = UIImage(named: "wall1")!
        } else if theme.fileName == fileName {
            isPicked = true
            themeUIImage = loadThemeImgFromDisk(path: UserDe.Local_ThemeImg)
        } else {
            ThemeManager.shared.fetchAThemeImage(themeTitle: theme.title, fileName: theme.fileName) { uiImage in
                if let uiImg = uiImage {
                    themeUIImage = uiImg
                } else {
                    themeUIImage = UIImage(named: "wall1")!
                }
            }
        }
    }
    
    
    func chooseThemeImg() {
        if !isPicked {
            saveImage(path: UserDe.Local_ThemeImg, image: themeUIImage)
            UserDefaults.standard.set(theme.isDarkText == "true", forKey: UserDe.isDarkText)
            UserDefaults.standard.set(theme.fileName, forKey: UserDe.themeFileName)
            showTheme.toggle()
        }
    }
    
    private func saveImage(path: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let p = path
        let fileURL = documentsDirectory.appendingPathComponent(p)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path) //remove old img
            } catch let err {
                print("DEBUG_ThemeCell: cannot remove file at path", err.localizedDescription)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let err {
            print("DEBUG_ThemeCell: error saving file with error", err.localizedDescription)
        }
        
    }
    
}

#Preview {
    ThemeCell(showTheme: .constant(false), isPicked: false, theme: Theme.mockThemeArr[0])
}
