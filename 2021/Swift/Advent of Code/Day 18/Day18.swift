//
//  Day18.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day18: Day {
  
  func part1() -> String {
    let nums = makeSnailfishNumbers()
    
    return ""
  }
  
  func part2() -> String {
    return ""
  }
  
  enum SnailfishError: Error {
    case parseError
  }
  
  func makeSnailfishNumbers() -> [SnailfishNumber] {
    input.lines().compactMap { str in
      return try! snailfishNumber(from: str)
    }
  }
  
  func snailfishNumber(from string: String) throws -> SnailfishNumber {
    // represented like "[[[[1,2],[3,4]],[[5,6],[7,8]]],9]"
    // ASSume well-structured input
    // find left and right of pair
    var depth = 0
    let commaIndex = string.firstIndex { c in
      if c == "," && depth == 1 {
        return true
      }
      if c == "[" {
        depth += 1
      } else if c == "]" {
        depth -= 1
      }
      return false
    }
    guard let commaIndex = commaIndex else {
      throw SnailfishError.parseError
    }

    let left = string[string.startIndex..<commaIndex].dropFirst()
    let right = string[string.index(after: commaIndex)..<string.endIndex].dropLast()
    
    var leftElem: SnailfishElement?
    var rightElem: SnailfishElement?
    
    if let num = Int(left) {
      leftElem = .regular(num)
    } else {
      leftElem = try .pair(snailfishNumber(from: String(left)))
    }
    
    if let num = Int(right) {
      rightElem = .regular(num)
    } else {
      rightElem = try .pair(snailfishNumber(from: String(right)))
    }
    
    if let l = leftElem, let r = rightElem {
      return SnailfishNumber(left: l, right: r)
    } else {
      throw SnailfishError.parseError
    }
  }
  
  class SnailfishNumber {
    private(set) var left: SnailfishElement
    private(set) var right: SnailfishElement
    private(set) weak var parent: SnailfishNumber? = nil
    
    init(left: SnailfishElement, right: SnailfishElement) {
      self.left = left
      self.right = right
      
      if case .pair(let sfn) = left {
        sfn.parent = self
      }
      if case .pair(let sfn) = right {
        sfn.parent = self
      }
    }
    
    // [1,2] + [[3,4],5] becomes [[1,2],[[3,4],5]]
    static func + (lhs: SnailfishNumber, rhs: SnailfishNumber) -> SnailfishNumber {
      SnailfishNumber(left: .pair(lhs), right: .pair(rhs))
    }
    
    func reduce() {
      /*
       To reduce a snailfish number, you must repeatedly do the first action in this list that applies to the snailfish number:
       - If any pair is nested inside four pairs, the leftmost such pair explodes.
       - If any regular number is 10 or greater, the leftmost such regular number splits.
       */
    }
    
    func depth() -> Int {
      var depth = 0
      var above = parent
      while above != nil {
        depth += 1
        above = above?.parent
      }
      return depth
    }
    
    func firstNestedInsideFourPairs() -> SnailfishNumber? {
      var found: SnailfishNumber? = nil
      if case (.regular(_), .regular(_)) = (left, right),
         self.depth() >= 4  {
        found = self
      }
      if found == nil,
         case let .pair(leftPair) = left {
        found = leftPair.firstNestedInsideFourPairs()
      }
      if found == nil,
         case let .pair(rightPair) = right {
        found = rightPair.firstNestedInsideFourPairs()
      }
      return found
    }
  }
  
  enum SnailfishElement {
    case regular(Int)
    case pair(SnailfishNumber)
  }

}

extension Day18.SnailfishNumber: CustomStringConvertible {
  var description: String {
    "[\(left),\(right)]"
  }
}

extension Day18.SnailfishElement: CustomStringConvertible {
  var description: String {
    switch self {
    case let .regular(reg):
      return String(reg)
    case let.pair(sfn):
      return "\(sfn)"
    }
  }
}
