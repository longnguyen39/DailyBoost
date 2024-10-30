//
//  String+Ext.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/21/24.
//

import SwiftUI

extension String {
    
//MARK: - Category and Purpose screen
    
    func getTitle() -> String {
        let pos = findCharPos(needle: "/", str: self)
        let index = self.index(self.startIndex, offsetBy: pos)
        return String(self[..<index])
    }
    
    func getCate() -> String {
        let pos = findCharPos(needle: "/", str: self)
        let index = self.index(self.startIndex, offsetBy: pos+1) //to avoid the '/'
        return String(self[index...])
    }
    

//MARK: Uploading quotes
    
    
    
    
}
