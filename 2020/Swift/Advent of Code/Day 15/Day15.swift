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
  
  typealias HistoryRecord = (mostRecent: Int, previous: Int?)
  
  func numberSpoken(onTurn stop: Int) -> Int {
    var history = [Int: HistoryRecord]() // key: number, value: history for the number
    var t = 0
    var last = 0 /// the last number that was spoken
    input.lines().first!.components(separatedBy: ",").compactMap { Int($0) }.forEach {
      t += 1
      last = $0
      history[last] = HistoryRecord(t, nil)
    }
    
    repeat {
      t += 1
      guard let record = history[last] else { return -1 /* error */ }
      if let previous = record.previous {
        // If not first time the number has been spoken: the number had been spoken before; the current player announces how many turns apart the number is from when it was previously spoken.
        last = record.mostRecent - previous
      } else {
        // If that was the first time the number has been spoken, the current player says 0.
        last = 0
      }
      history[last] = HistoryRecord(t, history[last]?.mostRecent)
    } while t < stop
    
    return last
  }
}

