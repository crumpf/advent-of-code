//
//  Day1.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

extension Array where Element == Int {
  func pairs(havingSum sum: Int) -> [(Int, Int)] {
    var pairs: [(Int, Int)] = []
    var elements = self
    while !elements.isEmpty {
      let a = elements.removeFirst()
      for b in elements {
        if a + b == sum {
          pairs.append((a, b))
        }
      }
    }
    return pairs
  }
  
  func trios(havingSum sum: Int) -> [(Int, Int, Int)] {
    var trios: [(Int, Int, Int)] = []
    guard count >= 3 else {
      return trios
    }
    
    for a in 0..<(self.count-2) {
      for b in (a+1)..<(self.count-1) {
        for c in (b+1)..<self.count where self[a] + self[b] + self[c] == sum {
          trios.append((self[a], self[b], self[c]))
        }
      }
    }
    return trios
  }
}

class Day1: Day {
  /// Find the two entries that sum to 2020; what do you get if you multiply them together?
  func part1() -> String {
    let pairs = entries().pairs(havingSum: 2020)
    return String(pairs.map { $0.0 * $0.1 }.first!)
  }

  /// What is the product of the three entries that sum to 2020?
  func part2() -> String {
    let trios = entries().trios(havingSum: 2020)
    return String(trios.map { $0.0 * $0.1 * $0.2 }.first!)
  }
  
  /// Make entries from the puzzle input.
  private func entries() -> [Int] {
    input.lines().compactMap { Int($0) }
  }
}
