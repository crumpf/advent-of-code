//
//  Day11.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

typealias Location = SIMD2<Int>

extension Array where Element == [Character] {
  func applyingAdjacentRules() -> [[Character]] {
    var changedLayout = self
    for (y, row) in self.enumerated() {
      for (x, value) in row.enumerated() {
        switch value {
        case "L":
          if self.countAdjacentOccupied(to: Location(x, y)) == 0 {
            changedLayout[y][x] = "#"
          }
        case "#":
          if self.countAdjacentOccupied(to: Location(x, y)) >= 4 {
            changedLayout[y][x] = "L"
          }
        default:
          break
        }
      }
    }
    return changedLayout
  }
  
  func countAdjacentOccupied(to loc: Location) -> Int {
    let adjacents = [loc &+ Location(-1, -1),
            loc &+ Location(0, -1),
            loc &+ Location(1, -1),
            loc &+ Location(-1, 0),
            loc &+ Location(1, 0),
            loc &+ Location(-1, 1),
            loc &+ Location(0, 1),
            loc &+ Location(1, 1)]
    return adjacents
      .filter { self.indices.contains($0.y) && self[$0.y].indices.contains($0.x) }
      .reduce(0) { $0 + (self[$1.y][$1.x] == "#" ? 1 : 0) }
  }
  
  func applyingVisibleRules() -> [[Character]] {
    var changedLayout = self
    for (y, row) in self.enumerated() {
      for (x, value) in row.enumerated() {
        switch value {
        case "L":
          if self.countVisibleOccupied(from: Location(x, y)) == 0 {
            changedLayout[y][x] = "#"
          }
        case "#":
          if self.countVisibleOccupied(from: Location(x, y)) >= 5 {
            changedLayout[y][x] = "L"
          }
        default:
          break
        }
      }
    }
    return changedLayout
  }
  
  func countVisibleOccupied(from loc: Location) -> Int {
    var visibleSeatLocations: [Location] = []
    let vectors = [Location(-1,-1), Location(0,-1), Location(1,-1), Location(-1,0), Location(1,0), Location(-1,1), Location(0,1), Location(1,1)]
    for vector in vectors {
      var possibleLocation = loc &+ vector
      while self.indices.contains(possibleLocation.y) && self[possibleLocation.y].indices.contains(possibleLocation.x) {
        if self[possibleLocation.y][possibleLocation.x] != "." {
          visibleSeatLocations.append(possibleLocation)
          break
        }
        possibleLocation = possibleLocation &+ vector
      }
    }
    
    return visibleSeatLocations.reduce(0) {
      $0 + (self[$1.y][$1.x] == "#" ? 1 : 0)
    }
  }
}

class Day11: Day {
  /// Simulate your seating area by applying the seating rules repeatedly until no seats change state. How many seats end up occupied?
  func part1() -> String {
    var layout = input.lines().map { Array($0) }
    
    while true {
      let iteratedLayout = layout.applyingAdjacentRules()
      if layout == iteratedLayout {
        break
      }
      layout = iteratedLayout
    }
    
    return String(layout.joined().filter { $0 == "#" }.count)
  }
  
  /// Given the new visibility method and the rule change for occupied seats becoming empty, once equilibrium is reached, how many seats end up occupied?
  func part2() -> String {
    var layout = input.lines().map { Array($0) }
    
    while true {
      let iteratedLayout = layout.applyingVisibleRules()
      if layout == iteratedLayout {
        break
      }
      layout = iteratedLayout
    }
    
    return String(layout.joined().filter { $0 == "#" }.count)
  }
  
  private func makeSeatLocations(layout: [[Character]]) -> [Location] {
    var seatLocs = [Location]()
    for (y, row) in layout.enumerated() {
      for (x, value) in row.enumerated() {
        if value != "." {
          seatLocs.append(Location(x,y))
        }
      }
    }
    return seatLocs
  }
}
