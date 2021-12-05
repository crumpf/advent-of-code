//
//  Day5.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/5/21.
//
//  https://adventofcode.com/2021/day/5

import Foundation

typealias Point = SIMD2<Int>

class Day5: Day {
  /// Consider only horizontal and vertical lines. At how many points do at least two lines overlap?
  func part1() -> String {
    // ventPoints = points where vents are mapped to their overlap count
    let ventPoints: [Point: Int] = lines
      .reduce(into: [Point: Int]()) { res, line in
        if line.0.x == line.1.x {
          // horz
          let range = line.0.y < line.1.y ? line.0.y...line.1.y : line.1.y...line.0.y
          for y in range {
            let pt = Point(line.0.x, y)
            res[pt] = 1 + (res[pt] ?? 0)
          }
        } else if line.0.y == line.1.y {
          // vert
          let range = line.0.x < line.1.x ? line.0.x...line.1.x : line.1.x...line.0.x
          for x in range {
            let pt = Point(x, line.0.y)
            res[pt] = 1 + (res[pt] ?? 0)
          }
        }
        // else non-orthogonal lines not considred
      }
    let overlap = ventPoints.filter { $0.value >= 2 }.count
    return "\(overlap)"
  }
  
  ///
  func part2() -> String {
    ""
  }
  
  private(set) lazy var lines: [(Point, Point)] = input
    .lines()
    .compactMap {
      let parts = $0.components(separatedBy: " -> ")
      guard parts.count == 2,
            let first = makePoint(commaSeparated: parts[0]),
            let second = makePoint(commaSeparated: parts[1])
      else {
        print("Invalid input found.")
        return nil
      }
      return (first, second)
    }
  
  private func makePoint(commaSeparated: String) -> Point? {
    let parts = commaSeparated.split(separator: ",")
    guard parts.count == 2,
          let x = Int(parts[0]),
          let y = Int(parts[1])
    else {
      return nil
    }
    return Point(x, y)
  }
      
}
