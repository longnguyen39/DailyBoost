//
//  CategoryScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//

import SwiftUI

struct CategoryScreen: View {
    
    @AppStorage(currentUserDefaults.userID) var userID: String? //this on constantly pull data from userDefaults (if data from userDefaults change, it also changes live)

    @Binding var showCate: Bool
    @Binding var chosenCatePathArr: [String]
    @Binding var refetch: Bool
    
//    @State var searchText: String = ""
//    @State var searchIsActive = false
    
    @State var showCateQuotesScr: Bool = false
    @State var isChanged: Bool = false
    
    @State var removeCateForYou: String = ""
    @State var addCateForYou: String = ""
    
    @State var fictionPicked: FictionOption = .both
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    FictionSection(fictionPicked: $fictionPicked, isChanged: $isChanged)
                        .padding()
                    
                    YourCateHScrollV(chosenCatePathArr: $chosenCatePathArr, removeCateForYou: $removeCateForYou, showCateQuotes: $showCateQuotesScr)
                        .padding(.bottom)
                        .padding(.top, 8)
                    
                    ForEach(CateTitle.allCases, id: \.self) { order in
                        CateHScrollV(caseOrder: order, chosenCatePathArr: $chosenCatePathArr, removeCateForYou: $removeCateForYou, addCateForYou: $addCateForYou, showCateQuotes: $showCateQuotesScr)
                    }
                }
                
                Button {
                    Task {
                        await saveChanges()
                    }
                } label: {
                    ThemeBtnView(context: "Show \(chosenCatePathArr.count) categories")
                        .fontWeight(.medium)
                }
            }
            .navigationTitle("Category")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                setFictionPicked()
            }
            .onChange(of: chosenCatePathArr) { _ in
                isChanged = true
            }
            .fullScreenCover(isPresented: $showCateQuotesScr) {
                CateQuotesScreen(showCateQuotesScr: $showCateQuotesScr, chosenCatePathArr: $chosenCatePathArr, removeCateForYou: $removeCateForYou, addCateForYou: $addCateForYou)
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
    @Binding var removeCateForYou: String
    @Binding var showCateQuotes: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Your categories (\(chosenCatePathArr.count))")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Spacer()
            }
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 12) {
                    ForEach(chosenCatePathArr, id: \.self) { cateP in
                        CateCellForYou(removeCateForYou: $removeCateForYou, chosenCatePathArr: $chosenCatePathArr, cateP: cateP, showCateQuotes: $showCateQuotes)
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .frame(height: 102)
        }
    }
}

//MARK: ------------------------------------------------

struct FictionSection: View {
    
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
    }
}

struct FictionRow: View {
    
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
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(isPicked() ? .gray : .black)
                Spacer()
                
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .fontWeight(.medium)
                    .foregroundStyle(isPicked() ? .black : .clear)
                    .padding(.all, 8)
                    .background(isPicked() ? .yellow : .clear)
                    .clipShape(.circle)
            }
            .padding(.horizontal)
        }
    }
    
    //MARK: - Function
    
    private func isPicked() -> Bool {
        return fictionPicked == fictionOption
    }
    
    private func updateFictionOption() async {
        let uid = userID ?? ""
        await ServiceUpload.shared.updateFictionOption(userID: uid, opt: fictionPicked.name)
    }
}
