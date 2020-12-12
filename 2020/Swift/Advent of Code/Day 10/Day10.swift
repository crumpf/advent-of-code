//
//  Day10.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day10: Day {
  /// Find a chain that uses all of your adapters to connect the charging outlet to your device's built-in adapter and count the joltage differences between the charging outlet, the adapters, and your device. What is the number
  func part1() -> String {
    let joltages = input.lines().compactMap { Int($0) }.sorted()
    let runs = makeRuns(joltages: joltages)

    // we now have runs: which are arrays that each have some number of joltages that are all 1 apart
    let diffOf1 = runs.reduce(0) { $0 + $1.count } - runs.count
    let diffOf3 = runs.count
    
    return String(diffOf1 * diffOf3)
  }
  
  /// What is the total number of distinct ways you can arrange the adapters to connect the charging outlet to your device?
  func part2() -> String {
    let joltages = input.lines().compactMap { Int($0) }.sorted()
    let runs = makeRuns(joltages: joltages)
    
    // permutations for a run, key:run length, value:perms
    let permMap = [1:1, 2:1, 3:2, 4:4, 5:7] // when debugging, I didn't see any runs > 5, so I'm not accounting for anything bigger
    let perms = runs.reduce(1) { $0 * permMap[$1.count]! } // with this unwrap we'll go down in flames if there's a run I haven't accounted for in my map 😰
    
    return String(perms)
  }
  
  // separate the input into sequential runs, each run being 3 apart from the next
  private func makeRuns(joltages: [Int]) -> [[Int]] {
    var runs: [[Int]] = []
    var run: [Int] = [0] // start with the output joltage
    for joltage in joltages.sorted() {
      let diff = joltage - run.last!
      switch diff {
      case 1:
        run.append(joltage)
      case 3:
        runs.append(run)
        run = [joltage]
      default:
        print("Found a diff other than 1 or 3: \(diff)")
      }
    }
    runs.append(run)
    return runs
  }
}
