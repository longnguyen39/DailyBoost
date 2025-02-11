//
//  CateHScrollV.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/23/24.
//

import SwiftUI

struct CateHScrollV: View {
    
    var caseOrder: CateTitle
    @Binding var chosenCatePathArr: [String]
    @Binding var showCateQuotes: Bool
    
    let rows: [GridItem] = [GridItem(.flexible()),
                            GridItem(.flexible())] // 2 rows
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(caseOrder.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Spacer()
            }
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, spacing: 10) {
                    switch caseOrder {
                    case .one:
                        ForEach(Cate1_LoveSelf.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.one.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr, showCateQuotes: $showCateQuotes)
                        }
                    case .two:
                        ForEach(Cate2_Hard.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.two.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr, showCateQuotes: $showCateQuotes)
                        }
                    case .three:
                        ForEach(Cate3_Mood.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.three.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr, showCateQuotes: $showCateQuotes)
                        }
                    case .four:
                        ForEach(Cate4_Prod.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.four.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr, showCateQuotes: $showCateQuotes)
                        }
                    case .five:
                        ForEach(Cate5_Relation.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.five.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr, showCateQuotes: $showCateQuotes)
                        }
                    case .six:
                        ForEach(Cate6_Sport.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.six.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr, showCateQuotes: $showCateQuotes)
                        }
                    case .seven:
                        ForEach(Cate7_Calm.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.seven.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr, showCateQuotes: $showCateQuotes)
                        }
                    case .eight:
                        ForEach(Cate8_Zodiac.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.eight.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr, showCateQuotes: $showCateQuotes)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .frame(height: 190)
        }
        .padding(.bottom, 32)
    }
}

#Preview {
    CateHScrollV(caseOrder: .eight, chosenCatePathArr: .constant(Quote.purposeStrArr), showCateQuotes: .constant(false))
}

