//
//  Day7.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/7/21.
//
//  https://adventofcode.com/2021/day/7

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
      let fuel = crabPositions.reduce(0) { $0 + abs($1 - pos) }
      if fuel < cheapest.fuel {
        cheapest = (pos, fuel)
      }
    }
    
    return "\(cheapest.position) (\(cheapest.fuel) fuel)"
  }
  
  func part2() -> String {
    guard let min = crabPositions.min(),
          let max = crabPositions.max()
    else {
      return "Error"
    }
    
    var cheapest: Cost = (0, Int.max)
    for pos in min...max {
      let fuel = crabPositions.reduce(0) { r, crab in
        let absDist = abs(crab - pos)
        let fuel = (0...absDist).reduce(0, +)
        return r + fuel
      }
      if fuel < cheapest.fuel {
        cheapest = (pos, fuel)
      }
    }
    
    return "\(cheapest.position) (\(cheapest.fuel) fuel)"
  }
  
  private(set) lazy var crabPositions = input.lines().first!.split(separator: ",").compactMap { Int($0) }
}

