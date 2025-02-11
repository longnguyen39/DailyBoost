//
//  CategoryScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//
//let GRAY_DARK = Color.gray.opacity(0.2)

import SwiftUI

struct CategoryScreen: View {
    
    @Environment(\.scenePhase) var scenePhase

    @AppStorage(currentUserDefaults.userID) var userID: String? //this on constantly pull data from userDefaults (if data from userDefaults change, it also changes live)

    @Binding var showCate: Bool
    @Binding var chosenCatePathArr: [String]
    @Binding var refetch: Bool
    
//    @State var searchText: String = ""
//    @State var searchIsActive = false
    
    @State var showCateQuotesScr: Bool = false
    @State var isChanged: Bool = false
        
    @State var fictionPicked: FictionOption = .both
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    FictionSection(fictionPicked: $fictionPicked, isChanged: $isChanged)
                        .padding()
                    
                    YourCateHScrollV(chosenCatePathArr: $chosenCatePathArr, showCateQuotes: $showCateQuotesScr)
                        .padding(.bottom, 32)
                        .padding(.top)
                    
                    ForEach(CateTitle.allCases, id: \.self) { order in
                        CateHScrollV(caseOrder: order, chosenCatePathArr: $chosenCatePathArr, showCateQuotes: $showCateQuotesScr)
                    }
                }
                
                Button {
                    Task {
                        await saveChanges()
                    }
                } label: {
                    ThemeBtnView(context: "Show \(chosenCatePathArr.count) categories")
                        .fontWeight(.medium)
                        .padding(.top, -8)
                }
            }
            .navigationTitle("Category")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                setFictionPicked()
            }
            .onChange(of: scenePhase) {
                if scenePhase == .background {
                    showCate = false
                }
            }
            .onChange(of: chosenCatePathArr) {
                isChanged = true
            }
            .fullScreenCover(isPresented: $showCateQuotesScr) {
                CateQuotesScreen(showCateQuotesScr: $showCateQuotesScr, chosenCatePathArr: $chosenCatePathArr)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if isChanged {
                            Task {
                                await saveChanges()
                            }
                        } else {
                            showCate.toggle()
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(
                        destination: CateAdjustScreen(showCate: $showCate, chosenCatePathArr: $chosenCatePathArr, refetch: $refetch, fictionPicked: $fictionPicked)
                    ) {
                        Image(systemName: "slider.horizontal.3")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                    }
                }
            }
        } //nav
//        .searchable(text: $searchText, isPresented: $searchIsActive)
    }
    
    private func setFictionPicked() {
        let optionName = UserDefaults.standard.object(forKey: UserDe.fictionOption) as? String ?? ""
        
        if optionName == FictionOption.nonFiction.name {
            fictionPicked = .nonFiction
        } else if optionName == FictionOption.fiction.name {
            fictionPicked = .fiction
        } else {
            fictionPicked = .both
        }
    }
    
    private func saveChanges() async {
        print("DEBUG_4: cate chosen is \(chosenCatePathArr.count)")
        
        //upload new arr to database
        UserDefaults.standard.set(fictionPicked.name, forKey: UserDe.fictionOption)
        await ServiceUpload.shared.updateCatePathArr(userID: userID ?? "nil", cateArr: chosenCatePathArr)
        
        //refetch quoteArr in HomeScr
        refetch.toggle()
        showCate.toggle()
    }
}

#Preview {
    CategoryScreen(showCate: .constant(false), chosenCatePathArr: .constant(Quote.purposeStrArr), refetch: .constant(false))
}

//MARK: ------------------------------------------------

struct YourCateHScrollV: View {
    
    @Binding var chosenCatePathArr: [String]
    @Binding var showCateQuotes: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your categories (\(chosenCatePathArr.count))")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Spacer()
            }
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 10) {
                    ForEach(chosenCatePathArr, id: \.self) { cateP in
                        CateCellForYou(chosenCatePathArr: $chosenCatePathArr, cateP: cateP, showCateQuotes: $showCateQuotes)
                            .transition(.scale)
                            .sensoryFeedback(.decrease, trigger: chosenCatePathArr)
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .frame(height: 96)
        }
    }
}

//MARK: ------------------------------------------------

struct FictionSection: View {
    
    @Environment(\.colorScheme) var mode

    @Binding var fictionPicked: FictionOption
    @Binding var isChanged: Bool
    
    var body: some View {
        VStack {
            CaptionView(context: "Includes quotes from famous fictional or non-fictional figures, or both.")
            .padding(.top, 12)
            
            FictionRow(fictionOption: .fiction, fictionPicked: $fictionPicked, isChanged: $isChanged).padding(.top, 4)
            Divider()
                .padding(.horizontal, 64)
                .padding(.bottom, 8)
                .opacity(0.7)
            
            FictionRow(fictionOption: .nonFiction, fictionPicked: $fictionPicked, isChanged: $isChanged).padding(.bottom, 8)
            Divider()
                .padding(.horizontal, 64)
                .padding(.bottom, 8)
                .opacity(0.7)
            
            FictionRow(fictionOption: .both, fictionPicked: $fictionPicked, isChanged: $isChanged)
                .padding(.bottom)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .background(mode == .light ? Color.white : Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct FictionRow: View {
    
    @Environment(\.colorScheme) var mode
    @AppStorage(currentUserDefaults.userID) var userID: String?
    var fictionOption: FictionOption
    
    @Binding var fictionPicked: FictionOption
    @Binding var isChanged: Bool
    
    var body: some View {
        Button {
            fictionPicked = fictionOption
            Task {
                await updateFictionOption()
                isChanged = true
            }
        } label: {
            HStack {
                Text(fictionOption.name)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundStyle(configForegroundC())
                Spacer()
                
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .fontWeight(.bold)
                    .foregroundStyle(isPicked() ? .white : .clear)
                    .padding(.all, 8)
                    .background(isPicked() ? .color3 : .clear)
                    .clipShape(.circle)
            }
            .padding(.horizontal)
        }
        .sensoryFeedback(.selection, trigger: fictionPicked)
    }
    
    //MARK: - Function
    
    private func configForegroundC() -> Color {
        if mode == .light {
            return isPicked() ? .gray : .black
        } else {
            return isPicked() ? .gray : .white
        }
    }
    
    private func isPicked() -> Bool {
        return fictionPicked == fictionOption
    }
    
    private func updateFictionOption() async {
        let uid = userID ?? ""
        await ServiceUpload.shared.updateFictionOption(userID: uid, opt: fictionPicked.name)
    }
}
