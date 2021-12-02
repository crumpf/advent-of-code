//
//  Day2.swift
//  Day 2
//
//  Created by Christopher Rumpf on 12/01/21.
//

import Foundation

class Day2: Day {

  /// What do you get if you multiply your final horizontal position by your final depth?
  func part1() -> String {
    let finalPos = course.reduce(into: (0, 0)) { res, step in
      switch step.0 {
      case "forward":
        res.0 += step.1
      case "down":
        res.1 += step.1
      case "up":
        res.1 -= step.1
      default:
        abort()
      }
    }
    print("Final position: \(finalPos)")
    return "\(finalPos.0 * finalPos.1)"
  }
  
  /// How many passwords are valid according to the new interpretation of the policies?
  func part2() -> String {
    "Not Implemented"
  }
  
  private(set) lazy var course: [(String, Int)] = input.lines()
    .map {
      let components = $0.components(separatedBy: .whitespaces)
      assert(components.count == 2, "Invalid input position data found: \($0)")
      return (components[0], Int(components[1])!)
    }
  
}
