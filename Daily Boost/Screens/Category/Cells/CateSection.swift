//
//  CateSection.swift
//  Daily Boost
//
//  Created by Long Nguyen on 2/6/25.
//

import SwiftUI

struct CateSection: View {
    
    @Environment(\.colorScheme) var mode
    
    var caseOrder: CateTitle
    @Binding var chosenCatePathArr: [String]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(caseOrder.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Spacer()
            }
            
            VStack(spacing: 8) {
                switch caseOrder {
                case .one:
                    ForEach(Cate1_LoveSelf.allCases, id: \.self) { cate in
                        CateRow(cateP: "\(CateTitle.one.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr)
                    }
                case .two:
                    ForEach(Cate2_Hard.allCases, id: \.self) { cate in
                        CateRow(cateP: "\(CateTitle.two.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr)
                    }
                case .three:
                    ForEach(Cate3_Mood.allCases, id: \.self) { cate in
                        CateRow(cateP: "\(CateTitle.three.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr)
                    }
                case .four:
                    ForEach(Cate4_Prod.allCases, id: \.self) { cate in
                        CateRow(cateP: "\(CateTitle.four.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr)
                    }
                case .five:
                    ForEach(Cate5_Relation.allCases, id: \.self) { cate in
                        CateRow(cateP: "\(CateTitle.five.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr)
                    }
                case .six:
                    ForEach(Cate6_Sport.allCases, id: \.self) { cate in
                        CateRow(cateP: "\(CateTitle.six.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr)
                    }
                case .seven:
                    ForEach(Cate7_Calm.allCases, id: \.self) { cate in
                        CateRow(cateP: "\(CateTitle.seven.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr)
                    }
                case .eight:
                    ForEach(Cate8_Zodiac.allCases, id: \.self) { cate in
                        CateRow(cateP: "\(CateTitle.eight.title)/\(cate.name)", chosenCatePathArr: $chosenCatePathArr)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 0.5)
                    .foregroundStyle(Color(.systemGray4))
                    .shadow(color: .black.opacity(0.4), radius: 2)
            }
            .background(mode == .light ? Color.white : Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
        }
        .navigationTitle("Pick your categories")
        .padding(.bottom, 40)

    }
}

#Preview {
    CateSection(caseOrder: .eight, chosenCatePathArr: .constant(Quote.purposeStrArr))
}
