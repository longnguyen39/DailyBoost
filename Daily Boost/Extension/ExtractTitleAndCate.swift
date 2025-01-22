//
//  ExtractTitleAndCate.swift
//  Daily Boost
//
//  Created by Long Nguyen on 9/3/24.
//

import Foundation

extension String {
    // "4.2>script is here.*author name"
    
    func getQScript() -> String {
        let catePath = self.getQCatePath()
        
        let position = findCharPos(needle: "*", str: self)
        if position != 0 {
            let index = self.index(self.startIndex, offsetBy: position)
            return String(self[..<index]).replacingOccurrences(of: "\(catePath)>", with: "")
        } else {
            return self.replacingOccurrences(of: "\(catePath)>", with: "") //author is nil
        }
    }
    
    func getQAuth() -> String {
        let pos = findCharPos(needle: "*", str: self)
        if pos == 0 {
            return ""
        } else {
            let index = self.index(self.startIndex, offsetBy: pos+1) //to avoid the '*'
            return String(self[index...])
        }
    }
    
    private func getQCatePath() -> String {
        let pos = findCharPos(needle: ">", str: self)
        let index = self.index(self.startIndex, offsetBy: pos)
        return String(self[..<index])
    }
    
    func getQTitle() -> String {
        var titlePath = self.getQCatePath()
        let pos = findCharPos(needle: ".", str: self)
        let index = self.index(self.startIndex, offsetBy: pos)
        titlePath = String(self[..<index])
        
        if titlePath == "1" {
            return CateTitle.one.title
        } else if titlePath == "2" {
            return CateTitle.two.title
        } else if titlePath == "3" {
            return CateTitle.three.title
        } else if titlePath == "4" {
            return CateTitle.four.title
        } else if titlePath == "5" {
            return CateTitle.five.title
        } else if titlePath == "6" {
            return CateTitle.six.title
        } else if titlePath == "7" {
            return CateTitle.seven.title
        } else if titlePath == "8" {
            return CateTitle.eight.title
        } else {
            return ""
        }
    }
    
    func getQCate() -> String {
        let titlePath = self.getQCatePath()
        let titleCase = titlePath.prefix(2).replacingOccurrences(of: ".", with: "") //valid if # of title < 100
        let cateOrder = titlePath.suffix(2).replacingOccurrences(of: ".", with: "") //valid if # of cate < 100
        
        if titleCase == "1" {
            return getCateFromTitle1(order: cateOrder)
        } else if titleCase == "2" {
            return getCateFromTitle2(order: cateOrder)
        } else if titleCase == "3" {
            return getCateFromTitle3(order: cateOrder)
        } else if titleCase == "4" {
            return getCateFromTitle4(order: cateOrder)
        } else if titleCase == "5" {
            return getCateFromTitle5(order: cateOrder)
        } else if titleCase == "6" {
            return getCateFromTitle6(order: cateOrder)
        } else if titleCase == "7" {
            return getCateFromTitle7(order: cateOrder)
        } else if titleCase == "8" {
            return getCateFromTitle8(order: cateOrder)
        } else {
            return ""
        }
    }
    
//------------------------------------------------------
//MARK: supplement for finding cate
    
    private func getCateFromTitle1(order: String) -> String {
        if order == "1" {
            return Cate1_LoveSelf.motivation.name
        } else if order == "2" {
            return Cate1_LoveSelf.badassMotiv.name
        } else if order == "3" {
            return Cate1_LoveSelf.mindfulness.name
        } else if order == "4" {
            return Cate1_LoveSelf.selfLove.name
        } else if order == "5" {
            return Cate1_LoveSelf.confidence.name
        } else if order == "6" {
            return Cate1_LoveSelf.ego.name
        } else if order == "7" {
            return Cate1_LoveSelf.beYourself.name
        } else if order == "8" {
            return Cate1_LoveSelf.positivity.name
        } else if order == "9" {
            return Cate1_LoveSelf.newStart.name
        } else if order == "10" {
            return Cate1_LoveSelf.moveOn.name
        } else if order == "11" {
            return Cate1_LoveSelf.growth.name
        } else if order == "12" {
            return Cate1_LoveSelf.gratitude.name
        } else if order == "13" {
            return Cate1_LoveSelf.selfDoubt.name
        } else if order == "14" {
            return Cate1_LoveSelf.women.name
        } else if order == "15" {
            return Cate1_LoveSelf.men.name
        } else {
            return ""
        }
    }
    
    private func getCateFromTitle2(order: String) -> String {
        if order == "1" {
            return Cate2_Hard.overthinking.name
        } else if order == "2" {
            return Cate2_Hard.uncertainty.name
        } else if order == "3" {
            return Cate2_Hard.frustration.name
        } else if order == "4" {
            return Cate2_Hard.missSomeone.name
        } else if order == "5" {
            return Cate2_Hard.heartBroken.name
        } else if order == "6" {
            return Cate2_Hard.overFear.name
        } else if order == "7" {
            return Cate2_Hard.beStrong.name
        } else if order == "8" {
            return Cate2_Hard.change.name
        } else if order == "9" {
            return Cate2_Hard.loneliness.name
        } else {
            return ""
        }
    }
    
    private func getCateFromTitle3(order: String) -> String {
        if order == "1" {
            return Cate3_Mood.sad.name
        } else if order == "2" {
            return Cate3_Mood.neutral.name
        } else if order == "3" {
            return Cate3_Mood.happy.name
        } else if order == "4" {
            return Cate3_Mood.relax.name
        } else if order == "5" {
            return Cate3_Mood.depress.name
        } else if order == "6" {
            return Cate3_Mood.grief.name
        } else if order == "7" {
            return Cate3_Mood.excited.name
        } else if order == "8" {
            return Cate3_Mood.angry.name
        } else {
            return ""
        }
    }
    
    private func getCateFromTitle4(order: String) -> String {
        if order == "1" {
            return Cate4_Prod.habit.name
        } else if order == "2" {
            return Cate4_Prod.routine.name
        } else if order == "3" {
            return Cate4_Prod.entrepreneur.name
        } else if order == "4" {
            return Cate4_Prod.productivity.name
        } else if order == "5" {
            return Cate4_Prod.focus.name
        } else if order == "6" {
            return Cate4_Prod.work.name
        } else if order == "7" {
            return Cate4_Prod.college.name
        } else if order == "8" {
            return Cate4_Prod.success.name
        } else if order == "9" {
            return Cate4_Prod.wealth.name
        } else if order == "10" {
            return Cate4_Prod.money.name
        } else if order == "11" {
            return Cate4_Prod.hustling.name
        } else if order == "12" {
            return Cate4_Prod.discipline.name
        } else if order == "13" {
            return Cate4_Prod.failure.name
        } else {
            return ""
        }
    }
    
    private func getCateFromTitle5(order: String) -> String {
        if order == "1" {
            return Cate5_Relation.trust.name
        } else if order == "2" {
            return Cate5_Relation.honesty.name
        } else if order == "3" {
            return Cate5_Relation.forgive.name
        } else if order == "4" {
            return Cate5_Relation.introvert.name
        } else if order == "5" {
            return Cate5_Relation.extrovert.name
        } else if order == "6" {
            return Cate5_Relation.love.name
        } else if order == "7" {
            return Cate5_Relation.friendship.name
        } else if order == "8" {
            return Cate5_Relation.family.name
        } else if order == "9" {
            return Cate5_Relation.parenthood.name
        } else if order == "10" {
            return Cate5_Relation.beSingle.name
        } else if order == "11" {
            return Cate5_Relation.fakePeople.name
        } else if order == "12" {
            return Cate5_Relation.teamwork.name
        } else if order == "13" {
            return Cate5_Relation.loyalty.name
        } else {
            return ""
        }
    }
    
    private func getCateFromTitle6(order: String) -> String {
        if order == "1" {
            return Cate6_Sport.health.name
        } else if order == "2" {
            return Cate6_Sport.competition.name
        } else if order == "3" {
            return Cate6_Sport.weightLoss.name
        } else if order == "4" {
            return Cate6_Sport.gym.name
        } else if order == "5" {
            return Cate6_Sport.run.name
        } else if order == "6" {
            return Cate6_Sport.excuse.name
        } else if order == "7" {
            return Cate6_Sport.grinding.name
        } else if order == "8" {
            return Cate6_Sport.giveup.name
        } else if order == "9" {
            return Cate6_Sport.recovery.name
        } else {
            return ""
        }
    }
    
    private func getCateFromTitle7(order: String) -> String {
        if order == "1" {
            return Cate7_Calm.sleep.name
        } else if order == "2" {
            return Cate7_Calm.calm.name
        } else if order == "3" {
            return Cate7_Calm.anxiety.name
        } else if order == "4" {
            return Cate7_Calm.perseverance.name
        } else if order == "5" {
            return Cate7_Calm.stress.name
        } else if order == "6" {
            return Cate7_Calm.smile.name
        } else if order == "7" {
            return Cate7_Calm.creative.name
        } else if order == "8" {
            return Cate7_Calm.harsh.name
        } else {
            return ""
        }
    }
    
    private func getCateFromTitle8(order: String) -> String {
        if order == "1" {
            return Cate8_Zodiac.virgo.name
        } else if order == "2" {
            return Cate8_Zodiac.aries.name
        } else if order == "3" {
            return Cate8_Zodiac.libra.name
        } else if order == "4" {
            return Cate8_Zodiac.sagittarius.name
        } else if order == "5" {
            return Cate8_Zodiac.scorpio.name
        } else if order == "6" {
            return Cate8_Zodiac.taurus.name
        } else if order == "7" {
            return Cate8_Zodiac.aquarius.name
        } else if order == "8" {
            return Cate8_Zodiac.capricorn.name
        } else if order == "9" {
            return Cate8_Zodiac.pisces.name
        } else if order == "10" {
            return Cate8_Zodiac.gemini.name
        } else if order == "11" {
            return Cate8_Zodiac.cancer.name
        } else if order == "12" {
            return Cate8_Zodiac.leo.name
        } else {
            return ""
        }
    }
}
