//
//  Day7.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/7/21.
//

import Foundation

typealias Cost = (position: Int, fuel: Int)

class Day7: Day {
  func part1() -> String {
    guard let min = crabPositions.min(),
          let max = crabPositions.max()
    else {
      return "Error"
    }
    
    var cheapest: Cost = (0, Int.max)
    for pos in min...max {
      let reduced = crabPositions.enumerated().reduce(Cost(pos, 0)) { r, crab in
        Cost(pos, r.fuel + abs(crab.element - pos))
      }
      if reduced.fuel < cheapest.fuel {
        cheapest = reduced
      }
    }
    
    return "\(cheapest.position) (\(cheapest.fuel) fuel)"
  }
  
  func part2() -> String {
    "Not Implemented"
  }
  
  private(set) lazy var crabPositions = input.lines().first!.split(separator: ",").compactMap { Int($0) }
}

