//
//  QuotesUpload.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/27/24.
//

import Foundation

/*
 
  1.1   Cate1_LoveSelf motivation
  1.2   Cate1_LoveSelf badassMotiv
  1.3   Cate1_LoveSelf mindfulness
  1.4   Cate1_LoveSelf selfLove
  1.5   Cate1_LoveSelf confidence
  1.6   Cate1_LoveSelf ego
  1.7   Cate1_LoveSelf beYourself
  1.8   Cate1_LoveSelf positivity
  1.9   Cate1_LoveSelf newStart
  1.10  Cate1_LoveSelf moveOn
  1.11  Cate1_LoveSelf growth
  1.12  Cate1_LoveSelf gratitude
  1.13  Cate1_LoveSelf selfDoubt
  1.14  Cate1_LoveSelf women
  1.15  Cate1_LoveSelf men
  
  2.1   Cate2_Hard overthinking
  2.2   Cate2_Hard uncertainty
  2.3   Cate2_Hard frustration
  2.4   Cate2_Hard missSomeone
  2.5   Cate2_Hard heartBroken
  2.6   Cate2_Hard overFear
  2.7   Cate2_Hard beStrong
  2.8   Cate2_Hard change
  2.9   Cate2_Hard loneliness
  
  3.1   Cate3_Mood sad
  3.2   Cate3_Mood neutral
  3.3   Cate3_Mood happy
  3.4   Cate3_Mood relax
  3.5   Cate3_Mood depress
  3.6   Cate3_Mood grief
  3.7   Cate3_Mood excited
  3.8   Cate3_Mood angry

  4.1   Cate4_Prod habit
  4.2   Cate4_Prod routine
  4.3   Cate4_Prod entrepreneur
  4.4   Cate4_Prod productivity
  4.5   Cate4_Prod focus
  4.6   Cate4_Prod work
  4.7   Cate4_Prod college
  4.8   Cate4_Prod success
  4.9   Cate4_Prod wealth
  4.10  Cate4_Prod money
  4.11  Cate4_Prod hustling
  4.12  Cate4_Prod discipline
  4.13  Cate4_Prod failure
  
  5.1   Cate5_Relation trust
  5.2   Cate5_Relation honesty
  5.3   Cate5_Relation forgive
  5.4   Cate5_Relation introvert
  5.5   Cate5_Relation extrovert
  5.6   Cate5_Relation love
  5.7   Cate5_Relation friendship
  5.8   Cate5_Relation family
  5.9   Cate5_Relation parenthood
  5.10  Cate5_Relation beSingle
  5.11  Cate5_Relation fakePeople
  5.12  Cate5_Relation teamwork
  5.13  Cate5_Relation loyalty
  
  6.1   Cate6_Sport Health
  6.2   Cate6_Sport Competition
  6.3   Cate6_Sport weightLoss
  6.4   Cate6_Sport gym
  6.5   Cate6_Sport run
  6.6   Cate6_Sport excuse
  6.7   Cate6_Sport grinding
  6.8   Cate6_Sport giveup
  6.9   Cate6_Sport recovery
  
  7.1   Cate7_Calm sleep
  7.2   Cate7_Calm calm
  7.3   Cate7_Calm anxiety
  7.4   Cate7_Calm perseverance
  7.5   Cate7_Calm stress
  7.6   Cate7_Calm smile
  7.7   Cate7_Calm creative
  7.8   Cate7_Calm harsh
  
  8.1   Cate8_Zodiac virgo
  8.2   Cate8_Zodiac aries
  8.3   Cate8_Zodiac libra
  8.4   Cate8_Zodiac sagittarius
  8.5   Cate8_Zodiac scorpio
  8.6   Cate8_Zodiac taurus
  8.7   Cate8_Zodiac aquarius
  8.8   Cate8_Zodiac capricorn
  8.9   Cate8_Zodiac pisces
  8.10  Cate8_Zodiac gemini
  8.11  Cate8_Zodiac cancer
  8.12  Cate8_Zodiac leo
 
 
 
 *** Fun
 
 */

struct Quotes {
    
//MARK: Quote report
//---------------------------------------------------------
    var sumTitle1: Int
    var sumTitle2: Int
    var sumTitle3: Int
    var sumTitle4: Int
    var sumTitle5: Int
    var sumTitle6: Int
    var sumTitle7: Int
    var sumTitle8: Int
    var sumAllTitle: Int
    
    static let sumInit: Quotes = Quotes(sumTitle1: 0, sumTitle2: 0, sumTitle3: 0, sumTitle4: 0, sumTitle5: 0, sumTitle6: 0, sumTitle7: 0, sumTitle8: 0, sumAllTitle: 0)
//---------------------------------------------------------

    
    //Now, we are uploading (isUploadingFiction) quotes
    static func getFictionOrNot() {
        isUploadingFiction = false
    }
    static let quoteUploadArr: [String] = [
        
        //template:
        //"1.3>Someone’s sitting in the shade today because someone planted a tree a long time ago.*Warren Buffet",
       
        

        
        
    ]
    
}
