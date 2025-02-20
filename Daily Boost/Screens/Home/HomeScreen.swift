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
    
    @Environment(\.colorScheme) var mode
    @Environment(AppDelegate.self) var appData
    @Environment(\.scenePhase) var scenePhase

    @AppStorage(UserDe.show_top_left) var show_top_left: Bool?
    @StateObject var vm = HomeScreenVM()
        
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
                        FeedCellScr(user: $vm.user, quote: quote)
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
                    await vm.notiChange(notiQPath: appData.notiQPath)
                }
            }
            .onAppear {
                Task {
                    await vm.screenAppear(notiQPath: appData.notiQPath)
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
                        CategoryBtnLbl(cateArr: vm.user.cateArr)
                    }
                    .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: vm.showCate)
                    
                    Spacer()
                    
                    Button {
                        vm.showTheme.toggle()
                    } label: {
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
            
            if vm.showStreak {
                StreakView
                    .ignoresSafeArea()
                    .animation(.spring, value: vm.showStreak)
            }
            
            if vm.showLoading {
                LoadingView()
            }
        }
        .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: vm.showStreak)
        .background { //this is the best background setup
            Image(uiImage: vm.themeUIImage)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.width, height: UIScreen.height)
                .ignoresSafeArea()
        }
        .onAppear {
            vm.themeUIImage = loadThemeImgFromDisk(path: UserDe.Local_ThemeImg)
        }
        .onChange(of: scenePhase) {
            print("DEBUG_HomeScr: \(scenePhase)")
            if scenePhase == .active {
                Task {
                    if !vm.user.userID.isEmpty {
                        print("DEBUG_HomeScr: check streak and set all noti...")
                        try? await Task.sleep(nanoseconds: 1_000_000_000)//delay 1s
                        vm.checkStreak()
                        if vm.getDiffsDay() != 0 {
                            await setAllNoti(user: vm.user)
                        } else {
                            print("DEBUG_HomeScr: app open same day, no new noti set.")
                        }
                    }
                }
            }
        }
        .onChange(of: vm.showTheme) {
            vm.themeUIImage = loadThemeImgFromDisk(path: UserDe.Local_ThemeImg)
        }
        .fullScreenCover(isPresented: $vm.showCate) {
            CategoryScreen(showCate: $vm.showCate, refetch: $vm.refetch, user: $vm.user)
        }
        .sheet(isPresented: $vm.showSetting) {
            SettingScreen(user: $vm.user, showSetting: $vm.showSetting)
        }
        .sheet(isPresented: $vm.showTheme) {
            ThemeScreen(showTheme: $vm.showTheme)
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
    var cateArr: [String]
    
    var body: some View {
        HStack {
            Image(systemName: "square.grid.2x2")
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(cateArr.count == 1 ? cateArr[0].getCate() : "Mix")
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
