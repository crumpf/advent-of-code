//
//  Day9.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day9: Day {
  func part1() -> String {
    var lowPoints: [Location] = []
    heightmap.enumerated().forEach { row in
      row.element.enumerated().forEach { col in
        let adjacentIndexes = [Location(row: row.offset - 1, col: col.offset),
                               Location(row: row.offset + 1, col: col.offset),
                               Location(row: row.offset, col: col.offset - 1),
                               Location(row: row.offset, col: col.offset + 1)]
        let isLowest = nil == adjacentIndexes.first {
          heightmap.indices.contains($0.row)
          && row.element.indices.contains($0.col)
          && heightmap[$0.row][$0.col] <= col.element
        }
        if isLowest {
          lowPoints.append(Location(row: row.offset, col: col.offset))
        }
      }
    }
    
    let risk = lowPoints.reduce(0) { $0 + (heightmap[$1.row][$1.col] + 1) }
    
    return "\(risk)"
  }
  
  func part2() -> String {
    ""
  }
  
  private(set) lazy var heightmap = input.lines().map { $0.compactMap { Int(String($0)) } }
}

struct Location {
  let row: Int
  let col: Int
}
