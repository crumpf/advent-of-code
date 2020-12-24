//
//  Day24.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day24: Day {
  private(set) var paths: [[String]] = []
  
  override init(input: String) {
    super.init(input: input)
    
    input.lines().forEach { line in
      paths.append(makePath(data: line))
    }
  }
  
  /// Go through the renovation crew's list and determine which tiles they need to flip. After all of the instructions have been followed, how many tiles are left with the black side up?
  func part1() -> String {
    var blackTileLocations = Set<SIMD2<Int>>()
    for path in paths {
      let tile = self.tile(at: path)
      if blackTileLocations.contains(tile) {
        blackTileLocations.remove(tile)
      } else {
        blackTileLocations.insert(tile)
      }
    }
    
    return String(blackTileLocations.count)
  }
  
  /// How many tiles will be black after 100 days?
  func part2() -> String {
    var blackTileLocations = Set<SIMD2<Int>>()
    for path in paths {
      let tile = self.tile(at: path)
      if blackTileLocations.contains(tile) {
        blackTileLocations.remove(tile)
      } else {
        blackTileLocations.insert(tile)
      }
    }
    
    print("Day 0: \(blackTileLocations.count)")
    
    for day in (1...100) {
      var blackTilesAfterRules = Set<SIMD2<Int>>()
      // Just searching a big map here. An improvement could be to search a range that just encompases the region of black tiles that we know about.
      (-500...500).forEach { y in
        (-500...500).forEach { x in
          let tile = SIMD2(x, y)
          let isBlack = blackTileLocations.contains(tile)
          let adj = adjacents(to: tile)
          let adjBlackCount = adj.filter { blackTileLocations.contains($0) }.count
          if isBlack {
            if (1...2).contains(adjBlackCount) {
              blackTilesAfterRules.insert(tile)
            }
          } else {
            if adjBlackCount == 2 {
              blackTilesAfterRules.insert(tile)
            }
          }
        }
      }
      blackTileLocations = blackTilesAfterRules
      print("Day \(day): \(blackTileLocations.count)")
    }
    
    return String(blackTileLocations.count)
  }
  
  private func makePath(data: String) -> [String] {
    var path: [String] = []
    var northSouth: Character?
    data.forEach { c in
      if c == "n" || c == "s" {
        northSouth = c
      } else if let ns = northSouth {
        path.append(String([ns, c]))
        northSouth = nil
      } else {
        path.append(String(c))
      }
    }
    return path
  }
  
  private func tile(at path: [String]) -> SIMD2<Int> {
    var current: SIMD2<Int> = SIMD2.zero
    for dir in path {
      switch dir {
      case "e":
        current &+= SIMD2(1, 0)
      case "se":
        current &+= SIMD2(1, -1)
      case "sw":
        current &+= SIMD2(0, -1)
      case "w":
        current &+= SIMD2(-1, 0)
      case "nw":
        current &+= SIMD2(-1, 1)
      case "ne":
        current &+= SIMD2(0, 1)
      default:
        abort()
      }
    }
    return current
  }
  
  private func adjacents(to tile: SIMD2<Int>) -> [SIMD2<Int>] {
    [tile &+ SIMD2(1, 0),
     tile &+ SIMD2(1, -1),
     tile &+ SIMD2(0, -1),
     tile &+ SIMD2(-1, 0),
     tile &+ SIMD2(-1, 1),
     tile &+ SIMD2(0, 1)]
  }
  
}

