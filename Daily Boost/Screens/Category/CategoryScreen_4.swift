//
//  CategoryScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//

import SwiftUI

struct CategoryScreen: View {
    
    @Binding var showCate: Bool
    @Binding var chosenCateArr: [String]
    @Binding var chosenTitleArr: [String]
    
    @State var searchText: String = ""
    
    @State var showFictions: Bool = true
    @State var showAuthorName: Bool = true
        
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ToggleSection(showFictions: $showFictions, showAuthors: $showAuthorName)
                        .padding()
                    
                    ForEach(CateTitle.allCases, id: \.self) { order in
                        CateHScrollV(caseOrder: order, chosenCateArr: $chosenCateArr)
                    }
                }
                
                Button {
                    print("DEBUG_4: \(chosenCateArr)")
                    showCate.toggle()
                } label: {
                    Text("Show 7 categories")
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
        .searchable(text: $searchText)
    }
}

#Preview {
    CategoryScreen(showCate: .constant(false), chosenCateArr: .constant(["Hello"]), chosenTitleArr: .constant(["Hello"]))
}

//MARK: ------------------------------------------------

struct ToggleSection: View {
    
    @Binding var showFictions: Bool
    @Binding var showAuthors: Bool
    
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
            
            Toggle("Show author's name", isOn: $showAuthors)
                .tint(.yellow)
                .fontWeight(.medium)
                .padding(.horizontal)
                .padding(.bottom, 12)
        }
        .overlay{
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
    }
}
