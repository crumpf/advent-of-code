//
//  Day2.swift
//  Day 2
//
//  Created by Christopher Rumpf on 12/01/21.
//
//  https://adventofcode.com/2021/day/2

import Foundation

class Day2: Day {

  /// What do you get if you multiply your final horizontal position by your final depth?
  func part1() -> String {
    let finalPos = course.reduce(into: (h:0, d:0)) { res, step in
      switch step.0 {
      case "forward":
        res.h += step.1
      case "down":
        res.d += step.1
      case "up":
        res.d -= step.1
      default:
        fatalError("Invalid course instruction: \(step)")
      }
    }
    print("Final position: \(finalPos)")
    return "\(finalPos.h * finalPos.d)"
  }
  
  /// How many passwords are valid according to the new interpretation of the policies?
  func part2() -> String {
    let finalPos = course.reduce(into: (h:0, d:0, a:0)) { res, step in
      switch step.0 {
      case "down":
        res.a += step.1
      case "up":
        res.a -= step.1
      case "forward":
        res.h += step.1
        res.d += res.a * step.1
      default:
        fatalError("Invalid course instruction: \(step)")
      }
    }
    print("Final position: \(finalPos)")
    return "\(finalPos.h * finalPos.d)"
  }
  
  private(set) lazy var course: [(String, Int)] = input.lines()
    .map {
      let components = $0.components(separatedBy: .whitespaces)
      assert(components.count == 2, "Invalid input position data found: \($0)")
      return (components[0], Int(components[1])!)
    }
  
}
