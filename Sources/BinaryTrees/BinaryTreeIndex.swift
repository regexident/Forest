//
//  BinaryTreeIndex.swift
//  Forest
//
//  Created by Vincent Esche on 7/25/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

public protocol BinaryTreeIndexPolicy {
	static func shouldSkipLeafs() -> Bool
}

public enum BinaryTreeStepType {
	case Root
	case LeftBranch
	case RightBranch
}

public struct BinaryTreeIndex<T: BinaryTreeType, P: BinaryTreeIndexPolicy>: BidirectionalIndexType {
	
	public typealias Tree = T
	public typealias Policy = P
	public typealias Distance = Int
	
	public typealias StepType = BinaryTreeStepType
	
	public let steps: [Tree]
	public let types: [StepType]
	
	public var lastStep: Tree {
		return self.steps.last!
	}
	
	public init(_ root: Tree) {
		self.steps = [root]
		self.types = [.Root]
	}
	
	private init(steps: [Tree], types: [StepType]) {
		assert(types[0] == .Root)
		assert(steps.count == types.count)
		self.steps = steps
		self.types = types
	}
	
	public func successor() -> BinaryTreeIndex {
		return self.step { _, r, i in
			var index = i
			r.traverseLeftwards { index = index.push($0, type: .LeftBranch) }
			return index
		}
	}
	
	public func predecessor() -> BinaryTreeIndex {
		return self.step { l, _, i in
			var index = i
			l.traverseRightwards { index = index.push($0, type: .RightBranch) }
			return index
		}
	}
	
	public func step(@noescape closure: (Tree, Tree, BinaryTreeIndex) -> BinaryTreeIndex) -> BinaryTreeIndex {
		var index = self
		var stop = false
		while !stop && !steps.isEmpty {
			let current = self.lastStep
			(index, stop) = current.analysis({ l, _, r in
				let newIndex = closure(l, r, index)
				return ((Policy.shouldSkipLeafs()) ? newIndex.pop() : newIndex, true)
			}, leaf: {
				return (index.pop(), false)
			})
		}
		return index
	}
	
	public func push(step: Tree, type: BinaryTreeStepType) -> BinaryTreeIndex {
		assert(type != .Root)
		var steps = self.steps
		steps.append(step)
		var types = self.types
		types.append(type)
		return BinaryTreeIndex(steps: steps, types: types)
	}
	
	public func pop() -> BinaryTreeIndex {
		return self.popAndReturn().0
	}
	
	func popAndReturn() -> (BinaryTreeIndex, Tree, BinaryTreeStepType) {
		assert(self.steps.count > 1)
		assert(self.types.count > 1)
		var steps = self.steps
		let step = steps.removeLast()
		var types = self.types
		let type = types.removeLast()
		return (BinaryTreeIndex(steps: steps, types: types), step, type)
	}
}

public func ==<T: BinaryTreeType, P: BinaryTreeIndexPolicy>(lhs: BinaryTreeIndex<T, P>, rhs: BinaryTreeIndex<T, P>) -> Bool {
	return (lhs.types == rhs.types)
}

extension BinaryTreeIndex {
	public var description: String {
		let lastStep = self.lastStep.analysis({ _, e, _ in "\(e)" }, leaf: { "nil" })
		return "<BinaryTreeIndex: \(lastStep)>"
	}
}

extension BinaryTreeIndex {
	public var debugDescription: String {
		let steps = self.steps.map { step in
			step.analysis({ _, e, _ in "\(e)" }, leaf: { "nil" })
		}
		return "<BinaryTreeIndex: \(steps)>"
	}
}