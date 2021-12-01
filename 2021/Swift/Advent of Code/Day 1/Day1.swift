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
    let changes = zip(measurements.dropFirst(), measurements).map { $0 - $1 }
    return String(changes.filter { $0 > 0 }.count)
  }

  /// ?
  func part2() -> String {
    let slidingSums = zip(measurements.dropFirst(2), zip(measurements.dropFirst(), measurements))
      .map { $0 + $1.0 + $1.1 }
    let changes = zip(slidingSums.dropFirst(), slidingSums).map { $0 - $1 }
    return String(changes.filter { $0 > 0 }.count)
  }
  
  private(set) lazy var measurements = input.lines().compactMap { Int($0) }
  
}
