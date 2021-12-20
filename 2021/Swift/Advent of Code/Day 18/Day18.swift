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
    let sum = addListOfSnailfishNumbers(nums)
    return "\(sum.magnitude())"
  }
  
  func part2() -> String {
    let nums = makeSnailfishNumbers()
    let largest = largestMagnitudeFrom2SnailfishNumbersInList(nums)
    return "\(largest)"
  }
  
  func addListOfSnailfishNumbers(_ list: [SnailfishNumber]) -> SnailfishNumber {
    var a = list[0]
    for b in list.dropFirst() {
      a = a + b
      a.reduce()
    }
    return a
  }
  
  func largestMagnitudeFrom2SnailfishNumbersInList(_ list: [SnailfishNumber]) -> Int {
    var largest = Int.min
    for a in list {
      for b in list {
        if "\(a)" != "\(b)" {
          let c = try! snailfishNumber(from: "\(a + b)")
          c.reduce()
          let mag = c.magnitude()
          if mag > largest {
            largest = mag
          }
        }
      }
    }
    return largest
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
    
    func add(_ elem: SnailfishElement, side: PairSide) {
      if case .pair(let sfn) = elem {
        sfn.parent = self
      }
      switch side {
      case .left:
        left = elem
      case .right:
        right = elem
      }
    }
    
    // [1,2] + [[3,4],5] becomes [[1,2],[[3,4],5]]
    static func + (lhs: SnailfishNumber, rhs: SnailfishNumber) -> SnailfishNumber {
      SnailfishNumber(left: .pair(lhs), right: .pair(rhs))
    }
    
    func magnitude() -> Int {
      3 * magnitudeOfElement(left) + 2 * magnitudeOfElement(right)
    }
    
    private func magnitudeOfElement(_ elem: SnailfishElement) -> Int {
      switch elem {
      case .regular(let value):
        return value
      case .pair(let p):
        return p.magnitude()
      }
    }
    
    func reduce() {
      /*
       To reduce a snailfish number, you must repeatedly do the first action in this list that applies to the snailfish number:
       - If any pair is nested inside four pairs, the leftmost such pair explodes.
       - If any regular number is 10 or greater, the leftmost such regular number splits.
       */
      while let found = self.firstNestedInsideFourPairs() {
        found.explode()
      }
      if splitFirst10OrGreater() {
        reduce()
      }
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
         self.depth() == 4  {
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
    
    func splitFirst10OrGreater() -> Bool {
      if case let .regular(num) = left,
         num >= 10 {
        let sfn = SnailfishNumber(left: .regular((num/2)), right: .regular(num - num/2))
        add(.pair(sfn), side: .left)
        return true
      }
      
      if case let .pair(p) = left,
         p.splitFirst10OrGreater() {
        return true
      }
          
      if case let .regular(num) = right,
         num >= 10 {
        let sfn = SnailfishNumber(left: .regular((num/2)), right: .regular(num - num/2))
        add(.pair(sfn), side: .right)
        return true
      }
      
      if case let .pair(p) = right,
         p.splitFirst10OrGreater() {
        return true
      }
      
      return false
    }
    
//    To explode a pair, the pair's left value is added to the first regular number to the left of the exploding pair (if any), and the pair's right value is added to the first regular number to the right of the exploding pair (if any). Exploding pairs will always consist of two regular numbers. Then, the entire exploding pair is replaced with the regular number 0.
    func explode() {
      parent?.explodeChildMatching(.pair(self))
    }
    
    func explodeChildMatching(_ sfn: SnailfishElement) {
      guard case let .pair(p) = sfn,
            case let .regular(leftValue) = p.left,
            case let .regular(rightValue) = p.right
      else {
        return
      }
      
      addToFirstRegularNumberUpTree(side: .left, value: leftValue, origin: sfn)
      addToFirstRegularNumberUpTree(side: .right, value: rightValue, origin: sfn)
      if sfn == left {
        left = .regular(0)
      }
      else if sfn == right {
        right = .regular(0)
      }
    }
    
    func addToFirstRegularNumberUpTree(side: PairSide, value: Int, origin: SnailfishElement) {
      switch side {
      case .left:
        if case let .regular(n) = left {
          left = .regular(n + value)
          return
        } else if origin != left,
                  case let .pair(p) = left {
          p.addToFirstRegularNumberDownTree(side: .right, value: value)
          return
        }
      case .right:
        if case let .regular(n) = right {
          right = .regular(n + value)
          return
        } else if origin != right,
                  case let .pair(p) = right {
          p.addToFirstRegularNumberDownTree(side: .left, value: value)
          return
        }
      }
      
      if let parent = parent {
        parent.addToFirstRegularNumberUpTree(side: side, value: value, origin: .pair(self))
      }
    }
    
    func addToFirstRegularNumberDownTree(side: PairSide, value: Int) {
      switch side == .left ? left : right {
      case let .regular(n):
        if side == .left {
          left = .regular(n + value)
        } else {
          right = .regular(n + value)
        }
      case let .pair(p):
        p.addToFirstRegularNumberDownTree(side: side, value: value)
      }
    }
    
  }
  
  enum SnailfishElement {
    case regular(Int)
    case pair(SnailfishNumber)
  }
  
  enum PairSide {
    case left, right
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

extension Day18.SnailfishElement: Equatable {
  static func == (lhs: Day18.SnailfishElement, rhs: Day18.SnailfishElement) -> Bool {
    switch (lhs, rhs) {
    case let (.regular(v1), .regular(v2)) where v1 == v2:
      return true
    case let (.pair(v1), .pair(v2)) where v1 === v2:
      return true
    default:
      return false
    }
  }
}
