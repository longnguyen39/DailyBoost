//
//  Array+Ext.swift
//  Daily Boost
//
//  Created by Long Nguyen on 5/28/24.
//

import Foundation

extension Array where Element: Hashable {
    
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
