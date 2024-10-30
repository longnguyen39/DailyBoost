//
//  UtilityFUnc.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/23/24.
//

import Foundation

func findCharPos(needle: Character, str: String) -> Int {
    if let idx = str.firstIndex(of: needle) {
        let pos = str.distance(from: str.startIndex, to: idx)
        return pos
    } else {
        return 0
    }
}

func randIntArr(title: String, cate: String) async throws -> [Int] {
    
    var arr: [Int] = []
    let count = await ServiceFetch.shared.fetchQuoteCount(title: title, cate: cate)
    
    if count >= 1 { //in case part of database got deleted
        for _ in 1...4 {
            let rand = Int.random(in: 1..<count)
            arr.append(rand)
        }
        return arr.removingDuplicates()
    } else {
        print("DEBUG_Helpers: count is \(count)")
        return [1]
    }
    
}

