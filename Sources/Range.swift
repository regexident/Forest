//
//  Range.swift
//  Forest
//
//  Created by Vincent Esche on 9/10/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

extension Range {
	func bisect() -> (Range, Index, Range)? {
		let count = self.startIndex.distanceTo(self.endIndex)
		if count < 1 {
			return nil
		}
		let index = self.startIndex.advancedBy(count / 2)
		return (self.startIndex..<index, index, (index.advancedBy(1))..<self.endIndex)
	}
}
