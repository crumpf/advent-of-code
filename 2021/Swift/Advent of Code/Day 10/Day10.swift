//
//  Day10.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day10: Day {
  func part1() -> String {
    let scanner = Scanner()
    let response = scanner.scanNavigationSubsystem(input.lines())
    let result = response.0.reduce(0) { $0 + (part1ScoreMap[$1.found] ?? 0) }
    return "\(result)"
  }
  
  func part2() -> String {
    let scanner = Scanner()
    let response = scanner.scanNavigationSubsystem(input.lines())
    let scores = response.1.map {
      $0.completion.reduce(0) {
        $0 * 5 + (part2ScoreMap[$1] ?? 0)
      }
    }
    let result = scores.sorted(by: >)[scores.count>>1]
    return "\(result)"
  }
  
  let part1ScoreMap: [Character: Int] = [")": 3, "]": 57, "}": 1197, ">": 25137]
  let part2ScoreMap: [Character: Int] = [")": 1, "]": 2, "}": 3, ">": 4]
}

struct CorruptedLine {
  let lineNumber: Int
  let index: Int
  let expected: Character
  let found: Character
}

struct IncompleteLine {
  let lineNumber: Int
  let completion: [Character]
}

struct Scanner {
  let openers: [Character] = ["(", "[", "{", "<"]
  let closers: [Character] = [")", "]", "}", ">"]
  let pairs: Zip2Sequence<[Character], [Character]>
  
  init() {
    pairs = zip(openers, closers)
  }
  
  func scanNavigationSubsystem(_ subsystem: [String]) -> ([CorruptedLine], [IncompleteLine]) {
    var corrupted: [CorruptedLine] = []
    var incomplete: [IncompleteLine] = []
    
    for (n, line) in subsystem.enumerated() {
      var stack: [Character] = []
      for c in line.enumerated() {
        if let _ = openers.firstIndex(of: c.element) {
          stack.append(c.element)
        } else if let opener = stack.popLast(),
                  let expected = pairs.first(where: { $0.0 == opener}),
                  c.element != expected.1 {
          corrupted.append(CorruptedLine(lineNumber: n, index: c.offset, expected: expected.1, found: c.element))
          stack.removeAll()
          break
        }
      }
      if !stack.isEmpty {
        let completion = stack.reversed().compactMap { opener in
          pairs.first(where: { $0.0 == opener })?.1
        }
        incomplete.append(IncompleteLine(lineNumber: n, completion: completion))
      }
    }
    
    return (corrupted, incomplete)
  }
}
