//
//  Tree.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/15/21.
//

import Foundation

class TreeNode<T> {
  private(set) var element: T
  private(set) var children: [TreeNode] = []
  private(set) weak var parent: TreeNode? = nil
  
  init(element: T) {
    self.element = element
  }
  
  func add(child: TreeNode) {
    child.parent = self
    children.append(child)
  }
}

extension TreeNode where T: Equatable {
  func search(element: T) -> TreeNode? {
    if element == self.element {
      return self
    }
    for child in children {
      if let found = child.search(element: element) {
        return found
      }
    }
    return nil
  }
}
