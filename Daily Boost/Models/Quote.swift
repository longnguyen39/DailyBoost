//
//  Quote.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/24/24.
//

import SwiftUI

struct Quote: Codable, Hashable { //Hashable when used in ForEach
    
    var orderNo: Int
    var script: String
    var title: String
    var category: String
    
    var isFictional: Bool
    
    var author: String
    
//MARK: - quotes will be used
    
    static var mockQuote: Quote = Quote(orderNo: 0, script: "No more quote!", title: "", category: "Welcome", isFictional: false, author: "")
        
//MARK: - purpose quotes
    
    static var purposeStrArr: [String] = [
        "\(CateTitle.one.title)/\(Cate1_LoveSelf.motivation.name)",
        "\(CateTitle.one.title)/\(Cate1_LoveSelf.positivity.name)",
        "\(CateTitle.one.title)/\(Cate1_LoveSelf.women.name)",
        "\(CateTitle.one.title)/\(Cate1_LoveSelf.men.name)",
        
        "\(CateTitle.two.title)/\(Cate2_Hard.overFear.name)",
        "\(CateTitle.two.title)/\(Cate2_Hard.loneliness.name)",
        
        "\(CateTitle.three.title)/\(Cate3_Mood.angry.name)",
        "\(CateTitle.three.title)/\(Cate3_Mood.depress.name)",
        
        "\(CateTitle.four.title)/\(Cate4_Prod.discipline.name)",
        "\(CateTitle.four.title)/\(Cate4_Prod.entrepreneur.name)",
        "\(CateTitle.four.title)/\(Cate4_Prod.failure.name)",
        
        "\(CateTitle.five.title)/\(Cate5_Relation.trust.name)",
        "\(CateTitle.five.title)/\(Cate5_Relation.friendship.name)",
        
        "\(CateTitle.six.title)/\(Cate6_Sport.health.name)",
        "\(CateTitle.six.title)/\(Cate6_Sport.recovery.name)",
        
        "\(CateTitle.seven.title)/\(Cate7_Calm.calm.name)",
        "\(CateTitle.seven.title)/\(Cate7_Calm.perseverance.name)",
        "\(CateTitle.seven.title)/\(Cate7_Calm.harsh.name)"
        
    ]
}

