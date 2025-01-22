//
//  UtilityFUnc.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/23/24.
//

import UIKit

func findCharPos(needle: Character, str: String) -> Int {
    if let idx = str.firstIndex(of: needle) {
        let pos = str.distance(from: str.startIndex, to: idx)
        return pos
    } else {
        return 0
    }
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" //length = 62
    return String((0..<length).map{ _ in letters.randomElement()! })
}


func loadThemeImgFromDisk(path: String) -> UIImage {
    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
    
    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
    
    if let dirPath = paths.first {
        let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(path)
        let image = UIImage(contentsOfFile: imageUrl.path)
        return image ?? UIImage(named: "wall1")!
    }
    return UIImage(named: "wall1")!
}
