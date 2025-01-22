//
//  QuoteReportScreen.swift
//  Daily Boost
//
//  Created by Long Nguyen on 10/30/24.
//

import SwiftUI

struct QuoteReportScreen: View {
    
    @State var sumOfATitle = Quotes.sumInit
    var isFiction: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Text("Total of all titles:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .padding()
                    Spacer()
                    
                    Text("\(sumOfATitle.sumAllTitle)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.pink)
                        .padding()
                }
                
                Divider().padding()
                
                ForEach(CateTitle.allCases, id: \.self) { caseOrder in
                    TitleReportCell(showDetail: false, title: caseOrder.title, sumOfATitle: $sumOfATitle, isFiction: isFiction)
                        .padding(.horizontal)
                }
                
                Divider().padding()
                
                ForEach(CateTitle.allCases, id: \.self) { caseOrder in
                    TitleReportCell(showDetail: true, title: caseOrder.title, sumOfATitle: $sumOfATitle, isFiction: isFiction)
                        .padding()
                }
            }
        }
        .navigationTitle("Quote Report")
    }
}

#Preview {
    QuoteReportScreen(isFiction: false)
}

//MARK: -----------------------------------------

struct TitleReportCell: View {
    
    var showDetail: Bool
    var title: String
    @Binding var sumOfATitle: Quotes
    var isFiction: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("\(title)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                Spacer()
                
                Text("\(yieldSum())")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
            }
            .padding(.vertical, 8)
            
            if showDetail {
                if title == CateTitle.one.title {
                    ForEach(Cate1_LoveSelf.allCases, id: \.self) { cate in
                        titleReportRow(title: title, cate: cate.name, isFiction: isFiction, sumOfATitle: $sumOfATitle)
                    }
                } else if title == CateTitle.two.title {
                    ForEach(Cate2_Hard.allCases, id: \.self) { cate in
                        titleReportRow(title: title, cate: cate.name, isFiction: isFiction, sumOfATitle: $sumOfATitle)
                    }
                } else if title == CateTitle.three.title {
                    ForEach(Cate3_Mood.allCases, id: \.self) { cate in
                        titleReportRow(title: title, cate: cate.name, isFiction: isFiction, sumOfATitle: $sumOfATitle)
                    }
                } else if title == CateTitle.four.title {
                    ForEach(Cate4_Prod.allCases, id: \.self) { cate in
                        titleReportRow(title: title, cate: cate.name, isFiction: isFiction, sumOfATitle: $sumOfATitle)
                    }
                } else if title == CateTitle.five.title {
                    ForEach(Cate5_Relation.allCases, id: \.self) { cate in
                        titleReportRow(title: title, cate: cate.name, isFiction: isFiction, sumOfATitle: $sumOfATitle)
                    }
                } else if title == CateTitle.six.title {
                    ForEach(Cate6_Sport.allCases, id: \.self) { cate in
                        titleReportRow(title: title, cate: cate.name, isFiction: isFiction, sumOfATitle: $sumOfATitle)
                    }
                } else if title == CateTitle.seven.title {
                    ForEach(Cate7_Calm.allCases, id: \.self) { cate in
                        titleReportRow(title: title, cate: cate.name, isFiction: isFiction, sumOfATitle: $sumOfATitle)
                    }
                } else if title == CateTitle.eight.title {
                    ForEach(Cate8_Zodiac.allCases, id: \.self) { cate in
                        titleReportRow(title: title, cate: cate.name, isFiction: isFiction, sumOfATitle: $sumOfATitle)
                    }
                }
            }
            
        }
    }
    
    private func yieldSum() -> Int {
        if title == CateTitle.one.title {
            return sumOfATitle.sumTitle1
        } else if title == CateTitle.two.title {
            return sumOfATitle.sumTitle2
        } else if title == CateTitle.three.title {
            return sumOfATitle.sumTitle3
        } else if title == CateTitle.four.title {
            return sumOfATitle.sumTitle4
        } else if title == CateTitle.five.title {
            return sumOfATitle.sumTitle5
        } else if title == CateTitle.six.title {
            return sumOfATitle.sumTitle6
        } else if title == CateTitle.seven.title {
            return sumOfATitle.sumTitle7
        } else if title == CateTitle.eight.title {
            return sumOfATitle.sumTitle8
        } else {
            return 0
        }
    }
}

//MARK: -----------------------------------------


struct titleReportRow: View {
    
    var title: String //for fetching only
    var cate: String
    var isFiction: Bool
    
    @Binding var sumOfATitle: Quotes
    @State var quoteInCate: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("\(cate)")
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundStyle(.black)
                Spacer()
                
                Text("\(quoteInCate)")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
            }
            
            Divider().padding(.vertical, 8)
        }
        .onAppear {
            Task {
                quoteInCate = await ServiceFetch.shared.fetchQuoteCount(title: title, cate: cate, isFiction: isFiction)
                computeSum()
                sumOfATitle.sumAllTitle += quoteInCate
            }
        }
    }
    
    private func computeSum() {
        if title == CateTitle.one.title {
            sumOfATitle.sumTitle1 += quoteInCate
        } else if title == CateTitle.two.title {
            sumOfATitle.sumTitle2 += quoteInCate
        } else if title == CateTitle.three.title {
            sumOfATitle.sumTitle3 += quoteInCate
        } else if title == CateTitle.four.title {
            sumOfATitle.sumTitle4 += quoteInCate
        } else if title == CateTitle.five.title {
            sumOfATitle.sumTitle5 += quoteInCate
        } else if title == CateTitle.six.title {
            sumOfATitle.sumTitle6 += quoteInCate
        } else if title == CateTitle.seven.title {
            sumOfATitle.sumTitle7 += quoteInCate
        } else if title == CateTitle.eight.title {
            sumOfATitle.sumTitle8 += quoteInCate
        }
    }
}
