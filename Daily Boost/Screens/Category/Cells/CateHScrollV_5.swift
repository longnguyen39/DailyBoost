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
    @Binding var user: User
    
    let rows: [GridItem] = [GridItem(.flexible()),
                            GridItem(.flexible())] // 2 rows
    
    var body: some View {
        VStack(spacing: 12) {
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
                    
                    case .zero:
                        ForEach(Cate0_MostPop.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(cate.title)/\(cate.name)", user: $user, chosenCatePathArr: $chosenCatePathArr)
                        }
                    case .one:
                        ForEach(Cate1_LoveSelf.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.one.title)/\(cate.name)", user: $user, chosenCatePathArr: $chosenCatePathArr)
                        }
                    case .two:
                        ForEach(Cate2_Hard.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.two.title)/\(cate.name)", user: $user, chosenCatePathArr: $chosenCatePathArr)
                        }
                    case .three:
                        ForEach(Cate3_Mood.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.three.title)/\(cate.name)", user: $user, chosenCatePathArr: $chosenCatePathArr)
                        }
                    case .four:
                        ForEach(Cate4_Prod.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.four.title)/\(cate.name)", user: $user, chosenCatePathArr: $chosenCatePathArr)
                        }
                    case .five:
                        ForEach(Cate5_Relation.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.five.title)/\(cate.name)", user: $user, chosenCatePathArr: $chosenCatePathArr)
                        }
                    case .six:
                        ForEach(Cate6_Sport.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.six.title)/\(cate.name)", user: $user, chosenCatePathArr: $chosenCatePathArr)
                        }
                    case .seven:
                        ForEach(Cate7_Calm.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.seven.title)/\(cate.name)", user: $user, chosenCatePathArr: $chosenCatePathArr)
                        }
                    case .eight:
                        ForEach(Cate8_Zodiac.allCases, id: \.self) { cate in
                            CateCell(cateP: "\(CateTitle.eight.title)/\(cate.name)", user: $user, chosenCatePathArr: $chosenCatePathArr)
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
    CateHScrollV(caseOrder: .eight, chosenCatePathArr: .constant(Quote.purposeStrArr), user: .constant(User.mockData))
}

