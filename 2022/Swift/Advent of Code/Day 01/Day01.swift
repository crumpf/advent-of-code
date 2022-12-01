//
//  Day01.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 11/30/22.
//

import Foundation

class Day01: Day {
  func part1() -> String {
    guard let max = elfCalorieLists.map({ $0.reduce(0, +) }).max() else {
      return ""
    }
    return "\(max)"
  }
  
  func part2() -> String {
    let totals = elfCalorieLists.map { $0.reduce(0, +) }.sorted(by: >)
    return "\(totals[0..<3].reduce(0, +))"
  }
  
  private(set) lazy var elfCalorieLists = input
    .components(separatedBy: "\n\n")
    .map {
      $0.components(separatedBy: .newlines).compactMap { Int($0) }
    }
}

