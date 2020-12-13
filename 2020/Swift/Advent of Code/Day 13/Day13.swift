//
//  Day13.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day13: Day {
  /// What is the ID of the earliest bus you can take to the airport multiplied by the number of minutes you'll need to wait for that bus?
  func part1() -> String {
    let lines = input.lines()
    let earliest = Int(lines[0])!
    let buses = lines[1].components(separatedBy: ",").compactMap { Int($0) }
    
    for timestamp in (earliest...) {
      for bus in buses {
        if timestamp % bus == 0 {
          let wait = timestamp - earliest
          return String(bus * wait)
        }
      }
    }
    
    return ""
  }
  
  /// What is the earliest timestamp such that all of the listed bus IDs depart at offsets matching their positions in the list?
  func part2() -> String {
    let lines = input.lines()
    let schedule = lines[1].components(separatedBy: ",").enumerated().filter { $1 != "x" }.map { (offset:$0.offset, bus:Int($0.element)!) }
    print(schedule)
    
    var t = 0
    var stride = 1
    var matchesSoFar = 0

    // starting at time 0, all the buses leave
    // check the list of buses to find the first N that satisfy their departure based on their index
    // if all match, hooray, this is the time!
    // if not, we keep a count of how many we've found so far
    // we can then increment the time we're checking by the least common multiple of the buses matched so far, we know that the pattern we're looking for won't show up any earlier than that period
    // keep going until we find the buses that match
    while true {
      let matches = busesMatchPositon(forTime: t, schedule: schedule)
      if matches == schedule.count {
        return String(t)
      } else if matches > matchesSoFar {
        matchesSoFar = matches
        stride = schedule[0..<matches].reduce(1) { lcm($0, $1.1) }
      } else if matches < matchesSoFar {
        return "Error. Something went wrong. We should never find less matches than we're already iterating on."
      }
      t += stride
    }
    
    return ""
  }
  
  /// returns the first n buses that match the schedule for a given time
  private func busesMatchPositon(forTime time: Int, schedule: [(offset:Int, bus:Int)]) -> Int {
    var matches = 0
    for s in schedule {
      if (time + s.offset) % s.bus != 0 { break }
      matches += 1
    }
    return matches
  }
    
  func gcd(_ a: Int, _ b: Int) -> Int {
      // Euclidean algorithm
      if b == 0 {
          return a
      }
      return gcd(b, a % b)
  }

  func lcm(_ a: Int, _ b: Int) -> Int {
      a * b / gcd(a, b)
  }

}

