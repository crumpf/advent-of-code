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
  
  func numberSpoken(onTurn stop: Int) -> Int {
    var whenLastSpoken: [Int: Int] = [:] // key: number, value: turn last spoken
    var t = 0
    var last = 0 /// the last number that was spoken
    input.lines().first!.components(separatedBy: ",").compactMap { Int($0) }.forEach {
      t += 1
      last = $0
      whenLastSpoken[last] = t
    }
    var whenPreviouslySpoken: [Int: Int] = [:]
    
    repeat {
      t += 1
      guard let lastTurn = whenLastSpoken[last] else { return -1 /* error */ }
      if whenPreviouslySpoken[last] == nil {
        // If that was the first time the number has been spoken, the current player says 0.
        last = 0
        whenPreviouslySpoken[last] = whenLastSpoken[last]
        whenLastSpoken[last] = t
      } else if let previousTurn = whenPreviouslySpoken[last] {
        // Otherwise, the number had been spoken before; the current player announces how many turns apart the number is from when it was previously spoken.
        last = lastTurn - previousTurn
        whenPreviouslySpoken[last] = whenLastSpoken[last]
        whenLastSpoken[last] = t
      } else {
        return -2  // error
      }
      
    } while t < stop
    
    return last
  }
}

