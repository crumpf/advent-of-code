//
//  Day5.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/5/21.
//
//  https://adventofcode.com/2021/day/5

import Foundation

class Day5: Day {
  /// Consider only horizontal and vertical lines. At how many points do at least two lines overlap?
  func part1() -> String {
    // ventPoints = points where vents are mapped to their overlap count
    let ventPoints: [SIMD2<Int>: Int] = lines
      .reduce(into: [SIMD2<Int>: Int]()) { res, line in
        if line.0.x == line.1.x {
          // horz
          let range = line.0.y < line.1.y ? line.0.y...line.1.y : line.1.y...line.0.y
          for y in range {
            let pt = SIMD2(x: line.0.x, y: y)
            res[pt] = 1 + (res[pt] ?? 0)
          }
        } else if line.0.y == line.1.y {
          // vert
          let range = line.0.x < line.1.x ? line.0.x...line.1.x : line.1.x...line.0.x
          for x in range {
            let pt = SIMD2<Int>(x: x, y: line.0.y)
            res[pt] = 1 + (res[pt] ?? 0)
          }
        }
        // else non-orthogonal lines not considred
      }
    let overlap = ventPoints.filter { $0.value >= 2 }.count
    return "\(overlap)"
  }
  
  /// Consider all of the lines. At how many points do at least two lines overlap?
  func part2() -> String {
    // ventPoints = points where vents are mapped to their overlap count
    let ventPoints: [SIMD2<Int>: Int] = lines
      .reduce(into: [SIMD2<Int>: Int]()) { res, line in
        // it's known that lines are orthoganal or diagonal
        let delta = line.1 &- line.0
        let direction = SIMD2(
          x: delta.x == 0 ? 0 : (delta.x > 0 ? 1 : -1),
          y: delta.y == 0 ? 0 : (delta.y > 0 ? 1 : -1)
        )
        let λMax = max(abs(line.0.x - line.1.x), abs(line.0.y - line.1.y))
        for λ in 0...λMax {
          let pt = line.0 &+ (λ &* direction)
          res[pt] = 1 + (res[pt] ?? 0)
        }
      }
    let overlap = ventPoints.filter { $0.value >= 2 }.count
    return "\(overlap)"
  }
  
  private(set) lazy var lines: [(SIMD2<Int>, SIMD2<Int>)] = input
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
  
  private func makePoint(commaSeparated: String) -> SIMD2<Int>? {
    let parts = commaSeparated.split(separator: ",")
    guard parts.count == 2,
          let x = Int(parts[0]),
          let y = Int(parts[1])
    else {
      return nil
    }
    return SIMD2(x, y)
  }
  
}
