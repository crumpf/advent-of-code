//
//  Day6.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//
//  https://adventofcode.com/2021/day/6

import Foundation

class Day6: Day {
  /// Find a way to simulate lanternfish. How many lanternfish would there be after 80 days?
  func part1() -> String {
    let count = countAfterSpawning(days: 80)
    return "\(count)"
  }
  
  /// How many lanternfish would there be after 256 days?
  func part2() -> String {
    let count = countAfterSpawning(days: 256)
    return "\(count)"
  }
  
  private(set) lazy var initialAges = input.lines().first!.split(separator: ",").compactMap { Int($0) }
  
  func countAfterSpawning(days: Int) -> Int {
    var fish = initialAges.reduce(into: Array(repeating: 0, count: 9), { res, time in
      res[time] += 1
    })
    for _ in 1...days {
      let spawn = fish.removeFirst()
      fish[6] += spawn
      fish.append(spawn)
    }
    return fish.reduce(0, +)
  }
  
}

