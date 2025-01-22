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
            
            if #available(iOS 17.0, *) {
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
                .ignoresSafeArea()
                .onAppear {
                    Task {
                        vm.showCateTopLeft = show_top_left ?? true
                        await vm.fetchUser()
                        await vm.screenAppear()
                    }
                }
                .onChange(of: vm.refetch) { _ in
                    Task {
                        await vm.refetchTriggered()
                    }
                }
                .onChange(of: vm.showTheme) { _ in
                    UserDefaults.standard.set(true, forKey: UserDe.themeNotFetch)
                }
                
            } else {
                Text("DEBUG_HomeScreen: Damn son! update to iOS 17+!")
            }
            
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    Button {
                        vm.showCate.toggle()
                    } label: {
                        CategoryBtnLbl()
                    }
                    
                    Spacer()
                    
                    Button {
                        vm.showTheme.toggle()
                    } label: {
                        //Image(systemName: "wand.and.stars")
                        StandardBtnLbl(imgName: "paintbrush")
                    }
                    
                    Button {
                        vm.showSetting.toggle()
                    } label: {
                        StandardBtnLbl(imgName: "gear")
                    }
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
        }
        .onChange(of: vm.showTheme) { _ in
            themeUIImage = loadThemeImgFromDisk(path: UserDe.Local_ThemeImg)
        }
        .fullScreenCover(isPresented: $vm.showCate) {
            CategoryScreen(showCate: $vm.showCate, chosenCatePathArr: $vm.chosenCatePathArr, refetch: $vm.refetch)
        }
        .sheet(isPresented: $vm.showSetting) {
            SettingScreen(user: $vm.user, showSetting: $vm.showSetting, showCateTopLeft: $vm.showCateTopLeft)
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
        .background(.gray.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct StandardBtnLbl: View {
    
    var imgName: String
    
    var body: some View {
        Image(systemName: imgName)
            .resizable()
            .frame(width: 24, height: 24)
            .padding(.all, 12)
            .background(.gray.opacity(0.72))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
