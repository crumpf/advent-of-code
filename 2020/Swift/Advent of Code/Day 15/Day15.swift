//
//  Day15.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day15: Day {
  /// Given your starting numbers, what will be the 2020th number spoken?
  func part1() -> String {
    String(numberSpoken(onTurn: 2020))
  }
  
  /// Given your starting numbers, what will be the 30000000th number spoken?
  func part2() -> String {
    String(numberSpoken(onTurn: 30000000))
  }
  
  func numberSpoken(onTurn turn: Int) -> Int {
    var lastSpoken: [Int: Int] = [:] // key: number, value: turn last spoken
    var t = 0
    var last = 0
    input.lines().first!.components(separatedBy: ",").compactMap { Int($0) }.forEach {
      t += 1
      last = $0
      lastSpoken[last] = t
    }
    var previouslySpoken: [Int: Int] = [:]
    
    repeat {
      t += 1
      guard let lastTurn = lastSpoken[last] else { return -1 }
      if previouslySpoken[last] == nil {
        last = 0
        previouslySpoken[last] = lastSpoken[last]
        lastSpoken[last] = t
      } else if let previousTurn = previouslySpoken[last] {
        last = lastTurn - previousTurn
        previouslySpoken[last] = lastSpoken[last]
        lastSpoken[last] = t
      } else {
        return -2
      }
      
    } while t < turn
    
    return last
  }
}

