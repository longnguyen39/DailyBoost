//
//  HomeScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/22/24.
//

import SwiftUI
import WebKit

struct HomeScreen: View {
    
    @StateObject var vm = HomeScreenVM()
    
    var body: some View {
        ZStack {
            Image("wall1")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            if #available(iOS 17.0, *) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.quoteArr, id: \.self) { quote in
                            FeedCellScr(quote: quote, isMainScreen: true, showInfo: $vm.showInfo)
                                .frame(width: UIScreen.width, height: UIScreen.height)
                                .onAppear {
                                    vm.cellAppear(quote: quote)
                                } //cell appear after each swipe
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
                .onAppear {
                    Task {
                        await vm.screenAppear()
                    }
                }
                .onChange(of: vm.refetch) { _ in
                    Task {
                        await vm.refetchTriggered()
                    }
                }
                
            } else {
                Text("DEBUG_HomeScreen: Damn son! update to iOS 17!")
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
                .padding()
            }
            .padding()
        }
        .fullScreenCover(isPresented: $vm.showCate) {
            CategoryScreen(showCate: $vm.showCate, chosenCatePathArr: $vm.chosenCatePathArr, refetch: $vm.refetch)
        }
        .fullScreenCover(isPresented: $vm.showSetting) {
            SettingScreen(showSetting: $vm.showSetting)
        }
        .fullScreenCover(isPresented: $vm.showTheme) {
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
        .background(.gray.opacity(0.5))
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
            .background(.gray.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
