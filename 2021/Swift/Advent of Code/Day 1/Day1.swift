//
//  Day1.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/01/21.
//
//  https://adventofcode.com/2021/day/1

import Foundation

class Day1: Day {
  
  /// How many measurements are larger than the previous measurement?
  func part1() -> String {
    let changes = zip(measurements.dropFirst(), measurements).map(-)
    return String(changes.filter { $0 > 0 }.count)
  }

  /// Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?
  func part2() -> String {
    let slidingSums = zip(measurements.dropFirst(2), zip(measurements.dropFirst(), measurements))
      .map { $0 + $1.0 + $1.1 }
    let changes = zip(slidingSums.dropFirst(), slidingSums).map(-)
    return String(changes.filter { $0 > 0 }.count)
  }
  
  /// Another implementation of Part2 using iteration over the measurements and taking and parameterized sliding window size, because why not?
  func part2(windowSize: Int) -> String {
    guard measurements.indices.contains(windowSize) else {
      return "Not enough measurements."
    }
    var count = 0
    for idx in windowSize..<measurements.endIndex {
      let firstSum = measurements[(idx-windowSize)..<idx].reduce(0, +)
      let secondSum = measurements[(idx-windowSize+1)...idx].reduce(0, +)
      if secondSum - firstSum > 0 {
        count += 1
      }
    }
    return String(count)
  }
  
  private(set) lazy var measurements = input.lines().compactMap { Int($0) }
  
}
