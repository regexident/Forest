//
//  CountableRange.swift
//  Forest
//
//  Created by Vincent Esche on 9/10/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

extension CountableRange {
    func bisect() -> (CountableRange, Index, CountableRange)? {
        let count = self.distance(from: self.startIndex, to: self.endIndex)
        if count < 1 {
            return nil
        }
        let index = self.index(self.startIndex, offsetBy: count / 2)
        let lower = self.startIndex..<index
        let upper = (self.index(index, offsetBy: 1))..<self.endIndex
        return (lower, index, upper)
    }
}
