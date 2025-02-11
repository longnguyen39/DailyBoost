//
//  HomeScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/22/24.
//

import SwiftUI
import WebKit

@MainActor //main thread
struct HomeScreen: View {
    
    @Environment(AppDelegate.self) private var appData
    @AppStorage(UserDe.show_top_left) var show_top_left: Bool?
    @StateObject var vm = HomeScreenVM()
    
    @State var themeUIImage: UIImage = UIImage(named: "wall1")!
    
    var body: some View {
        ZStack { //set background for this ZS, best setup
            
            //if we do below, the size of som img would mess up the UI of the entire screen
//            Image("wall1")
//                .resizable()
//                .scaledToFill()
//                .frame(minWidth: 0)
//                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(vm.quoteArr, id: \.self) { quote in
                        FeedCellScr(quote: quote, showInfo: $vm.showInfo, showCateOnTop: $vm.showCateTopLeft)
                            .frame(width: UIScreen.width, height: UIScreen.height)
                            .onAppear {
                                Task {
                                    await vm.cellAppear(quote: quote)
                                }
                            } //cell appear after each swipe
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
            .onChange(of: appData.notiQPath) {
                Task {
                    await vm.refetchTriggered()
                    
                    //for notification
                    if !appData.notiQPath.isEmpty {
                        let q = await vm.insertNotiQuote(quoteP: appData.notiQPath)
                        vm.quoteArr.insert(q, at: 0)
                    }
                }
            }
            .onAppear {
                Task {
                    vm.showCateTopLeft = show_top_left ?? true
                    await vm.fetchUser()
                    
                    //for notification
                    if !appData.notiQPath.isEmpty {
                        vm.histArr += await ServiceFetch.shared.fetchHistArr(userID: vm.user.userID)
                    } else {
                        await vm.screenAppear()
                    }
                }
            }
            .onChange(of: vm.refetch) {
                Task {
                    await vm.refetchTriggered()
                }
            }
            .onChange(of: vm.showTheme) {
                UserDefaults.standard.set(true, forKey: UserDe.themeNotFetch)
            }
            
            
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    Button {
                        vm.showCate.toggle()
                    } label: {
                        CategoryBtnLbl()
                    }
                    .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: vm.showCate)
                    
                    Spacer()
                    
                    Button {
                        vm.showTheme.toggle()
                    } label: {
                        //Image(systemName: "wand.and.stars")
                        StandardBtnLbl(imgName: "paintbrush")
                    }
                    .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: vm.showTheme)
                    
                    Button {
                        vm.showSetting.toggle()
                    } label: {
                        StandardBtnLbl(imgName: "gear")
                    }
                    .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: vm.showSetting)
                }
                .foregroundStyle(.white)
            }
            .padding()
            
            if vm.showLoading {
                LoadingView()
            }
        }
        .background { //this is the best background setup
            Image(uiImage: themeUIImage)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.width, height: UIScreen.height)
                .ignoresSafeArea()
        }
        .onAppear {
            themeUIImage = loadThemeImgFromDisk(path: UserDe.Local_ThemeImg)
            Task {
                await vm.loginDetect()
            }
        }
        .onChange(of: vm.showTheme) {
            themeUIImage = loadThemeImgFromDisk(path: UserDe.Local_ThemeImg)
        }
        .fullScreenCover(isPresented: $vm.showCate) {
            CategoryScreen(showCate: $vm.showCate, chosenCatePathArr: $vm.chosenCatePathArr, refetch: $vm.refetch)
        }
        .sheet(isPresented: $vm.showSetting) {
            SettingScreen(chosenCatePArr: vm.chosenCatePathArr, user: $vm.user, showSetting: $vm.showSetting, showCateTopLeft: $vm.showCateTopLeft)
        }
        .sheet(isPresented: $vm.showTheme) {
            ThemeScreen(showTheme: $vm.showTheme)
        }
        .sheet(isPresented: $vm.showInfo) {
            InfoScreen(showInfo: $vm.showInfo, quoteInfo: $vm.quoteInfo)
        }
    }
    
}

#Preview {
    HomeScreen()
}

//MARK: ---------------------------------------------

//Small View

struct CategoryBtnLbl: View {
    
    @AppStorage(UserDe.isDarkText) var isDarkText: Bool?
    
    var body: some View {
        HStack {
            Image(systemName: "square.grid.2x2")
                .resizable()
                .frame(width: 24, height: 24)
            
            Text("General")
                .font(.subheadline)
        }
        .padding(.all, 12)
        .fontWeight(.light)
        .background(isDarkText ?? false ? .black.opacity(0.4) : .gray.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct StandardBtnLbl: View {
    
    @AppStorage(UserDe.isDarkText) var isDarkText: Bool?
    
    var imgName: String
    
    var body: some View {
        Image(systemName: imgName)
            .resizable()
            .frame(width: 24, height: 24)
            .padding(.all, 12)
            .background(isDarkText ?? false ? .black.opacity(0.4) : .gray.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
