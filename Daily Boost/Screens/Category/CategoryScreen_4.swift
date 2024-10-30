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
    @Binding var showCateTopLeft: Bool
    
//    @State var searchText: String = ""
//    @State var searchIsActive = false
    
    @State var showFictions: Bool = true
    @State var showCateQuotes: Bool = false
    
    @State var removeCateForYou: String = ""
    @State var addCateForYou: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ToggleSection(showFictions: $showFictions, showCateTopLeft: $showCateTopLeft)
                        .padding()
                    
                    YourCateHScrollV(chosenCatePathArr: $chosenCatePathArr, removeCateForYou: $removeCateForYou, showCateQuotes: $showCateQuotes)
                        .padding(.bottom)
                    
                    ForEach(CateTitle.allCases, id: \.self) { order in
                        CateHScrollV(caseOrder: order, chosenCatePathArr: $chosenCatePathArr, removeCateForYou: $removeCateForYou, addCateForYou: $addCateForYou, showCateQuotes: $showCateQuotes)
                    }
                }
                
                Button {
                    print("DEBUG_4: cate chosen is \(chosenCatePathArr.count)")
                    
                    //upload new arr to database
                    Task {
                        try await ServiceUpload.shared.updateCatePathArr(userID: userID ?? "nil", cateArr: chosenCatePathArr)
                        
                        //refetch quoteArr in HomeScr
                        refetch.toggle()
                        showCate.toggle()
                    }
                } label: {
                    Text("Show \(chosenCatePathArr.count) categories")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                        .frame(width: UIScreen.width-32, height: 48)
                        .background(.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .navigationTitle("Category")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showCateQuotes) {
                CateQuotesScreen(showCateQuotes: $showCateQuotes, chosenCatePathArr: $chosenCatePathArr, removeCateForYou: $removeCateForYou, addCateForYou: $addCateForYou)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showCate.toggle()
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
}

#Preview {
    CategoryScreen(showCate: .constant(false), chosenCatePathArr: .constant(Quote.purposeStrArr), refetch: .constant(false), showCateTopLeft: .constant(false))
}

//MARK: ------------------------------------------------

struct YourCateHScrollV: View {
    
    @Binding var chosenCatePathArr: [String]
    @Binding var removeCateForYou: String
    @Binding var showCateQuotes: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Your categories")
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

struct ToggleSection: View {
    
    @Binding var showFictions: Bool
    @Binding var showCateTopLeft: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("*Include quotes from famous fictional figures")
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Toggle("Include Fictions", isOn: $showFictions)
                .tint(.yellow)
                .fontWeight(.medium)
                .padding(.horizontal)
                .padding(.bottom)
            
            Toggle("Show Category", isOn: $showCateTopLeft)
                .tint(.yellow)
                .fontWeight(.medium)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .onChange(of: showCateTopLeft) { _ in
            UserDefaults.standard.set(showCateTopLeft, forKey: UserDe.show_top_left)
        }
    }
}

