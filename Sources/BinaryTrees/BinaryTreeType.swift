//
//  BinaryTreeType.swift
//  Forest
//
//  Created by Vincent Esche on 2/12/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

public protocol BinaryTreeType : CustomStringConvertible, CustomDebugStringConvertible, Equatable {
	associatedtype Element
	
	init()

	func analysis<U>(branch: (Self, Element, Self) -> U, leaf: () -> U) -> U
}

extension BinaryTreeType {
	final public var element: Element? {
		return analysis(branch: { _, element, _ in
			element
		}, leaf: {
			nil
		})
	}
	
	final public var left: Self? {
		return analysis(branch: { left, _, _ in
			return (left.isNil) ? nil : left
		}, leaf: {
			nil
		})
	}
	
	final public var right: Self? {
		return analysis(branch: { _, _, right in
			return (right.isNil) ? nil : right
		}, leaf: {
			nil
		})
	}

    final public func preorder(_ closure: (Element) -> ()) {
        self.analysis(branch: { (l, e, r) -> () in
            closure(e)
            l.preorder(closure)
            r.preorder(closure)
        }, leaf: {})
    }

    final public func inorder(_ closure: (Element) -> ()) {
        self.analysis(branch: { (l, e, r) -> () in
            l.inorder(closure)
            closure(e)
            r.inorder(closure)
        }, leaf: {})
    }

    final public func postorder(_ closure: (Element) -> ()) {
        self.analysis(branch: { (l, e, r) -> () in
            l.postorder(closure)
            r.postorder(closure)
            closure(e)
        }, leaf: {})
    }

	final public var height: Int8 {
		return analysis(branch: { l, _, r in
			Swift.max(l.height, r.height) + 1
		}, leaf: {
			0
		})
	}
	
	final public var subtreeHeights: (Int, Int) {
		return analysis(branch: { l, _, r in
			(Int(r.height), Int(l.height))
		}, leaf: {
			(0, 0)
		})
	}
	
	final public var balance: Int {
		return analysis(branch: { l, _, r in
			r.height - l.height
		}, leaf: {
			0
		})
	}
	
	final public var count: Int {
		return analysis(branch: { l, _, r in
			l.count + 1 + r.count
		}, leaf: {
			0
		})
	}

	final public var isEmpty: Bool {
		return self.isNil
	}
	
	final public var isNil: Bool {
		return analysis(branch: { _, _, _ in
			false
		}, leaf: {
			true
		})
	}
	
	final func clear() -> Self {
		return Self()
	}

	final public func generate() -> AnyIterator<Element> {
		var stack: [Self] = [self]
		return AnyIterator { _ -> Element? in
			var current = stack.removeLast()
			while true {
				if current.isNil {
					if stack.isEmpty {
						return nil
					} else {
						current = stack.removeLast()
						return current.analysis(branch: { _, e, r in
							stack.append(r)
							return e
						}, leaf: { nil })
					}
				} else {
					current.analysis(branch: { l, _, _ in
						stack.append(current)
						current = l
						return
					}, leaf: { return })
				}
			}
		}
	}
	
	final public func traverseLeftwards(_ closure: (Self) -> ()) -> Self {
		closure(self)
		return analysis(branch: { l, _, _ in
			l.traverseLeftwards(closure)
		}, leaf: {
			self
		})
	}
	
	final public func traverseRightwards(_ closure: (Self) -> ()) -> Self {
		closure(self)
		return analysis(branch: { _, _, r in
			r.traverseRightwards(closure)
		}, leaf: {
			self
		})
	}

	final public func leftmostBranch() -> Self {
		var node = self
		let _ = traverseLeftwards {
			if !$0.isNil {
				node = $0
			}
		}
		return node
	}
	
	final public func rightmostBranch() -> Self {
		var node = self
        let _ = traverseRightwards {
			if !$0.isNil {
				node = $0
			}
		}
		return node
	}

	final public func recursiveDescription(_ closure: @escaping (Self) -> String?) -> String {
		return self.recursiveDescription("", flag: false, closure: closure)
	}
	
	final fileprivate func recursiveDescription(_ string: String, flag: Bool, closure: @escaping (Self) -> String?) -> String {
		var recursiveDescription : ((Self, String, Bool) -> String)! = nil
		recursiveDescription = { node, prefix, isTail in
			var string = ""
			if let element = closure(node) {
				if let right = node.right, right.analysis(branch: { _, _, _ in true }, leaf: { closure(right) != nil }) {
					string += recursiveDescription(right, prefix + ((isTail) ? "│  " : "   "), false)
				}
				string += prefix + ((isTail) ? "└─ " : "┌─ ") + "\(element)\n"
				if let left = node.left, left.analysis(branch: { _, _, _ in true }, leaf: { closure(left) != nil }) {
					string += recursiveDescription(left, prefix + ((isTail) ? "   " : "│  "), true)
				}
			}
			return string
		}
		return recursiveDescription(self, "", false)
	}

	final public var description: String {
		return self.recursiveDescription { return $0.analysis(branch: { _, e, _ in "\(e)" }, leaf: { nil }) }
	}

	final public var debugDescription: String {
		return self.recursiveDescription { return $0.analysis(branch: { _, e, _ in "\(e)" }, leaf: { "nil" }) }
	}
}
