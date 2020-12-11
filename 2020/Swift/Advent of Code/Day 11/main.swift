//
//  main.swift
//  Day 11
//
//  Created by Christopher Rumpf on 12/10/20.
//

import Foundation

typealias Location = SIMD2<Int>

class Day11 {
  func makeSeatLocations(layout: [[Character]]) -> [Location] {
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
  
  func numAdjacentOccupied(to loc: Location, layout: [[Character]]) -> Int {
    let adjacents = [loc &+ Location(-1, -1),
            loc &+ Location(0, -1),
            loc &+ Location(1, -1),
            loc &+ Location(-1, 0),
            loc &+ Location(1, 0),
            loc &+ Location(-1, 1),
            loc &+ Location(0, 1),
            loc &+ Location(1, 1)]
    return adjacents
      .filter { layout.indices.contains($0.y) && layout[$0.y].indices.contains($0.x) }
      .reduce(0) { $0 + (layout[$1.y][$1.x] == "#" ? 1 : 0) }
  }
  
  func applyRules(to layout: [[Character]], seatLocations: [Location]) -> [[Character]] {
    var changedLayout = layout
    seatLocations.forEach { (loc) in
      switch layout[loc.y][loc.x] {
      case "L":
        if numAdjacentOccupied(to: loc, layout: layout) == 0 {
          changedLayout[loc.y][loc.x] = "#"
        }
      case "#":
        if numAdjacentOccupied(to: loc, layout: layout) >= 4 {
          changedLayout[loc.y][loc.x] = "L"
        }
      default:
        break
      }
    }
    
    return changedLayout
  }
  
  // part 2 related methods
  
  func numVisibleOccupied(to loc: Location, layout: [[Character]]) -> Int {
    var visibleSeatLocations: [Location] = []
    let vectors = [Location(-1,-1),Location(0,-1),Location(1,-1),Location(-1,0),Location(1,0),Location(-1,1),Location(0,1),Location(1,1)]
    for vector in vectors {
      var possibleLocation = loc &+ vector
      while layout.indices.contains(possibleLocation.y) && layout[possibleLocation.y].indices.contains(possibleLocation.x) {
        if layout[possibleLocation.y][possibleLocation.x] != "." {
          visibleSeatLocations.append(possibleLocation)
          break
        }
        possibleLocation = possibleLocation &+ vector
      }
    }
    
    return visibleSeatLocations.reduce(0) {
      $0 + (layout[$1.y][$1.x] == "#" ? 1 : 0)
    }
  }
  
  func applyNewRules(to layout: [[Character]], seatLocations: [Location]) -> [[Character]] {
    var changedLayout = layout
    seatLocations.forEach { (loc) in
      switch layout[loc.y][loc.x] {
      case "L":
        if numVisibleOccupied(to: loc, layout: layout) == 0 {
          changedLayout[loc.y][loc.x] = "#"
        }
      case "#":
        if numVisibleOccupied(to: loc, layout: layout) >= 5 {
          changedLayout[loc.y][loc.x] = "L"
        }
      default:
        break
      }
    }
    return changedLayout
  }
}

extension Day11: Puzzle {
  func part1(withInput input: String) -> String {
    var layout = input.lines().map { Array($0) }
    let seatLocs = makeSeatLocations(layout: layout)
    
    while true {
      let changedLayout = applyRules(to: layout, seatLocations: seatLocs)
      if layout == changedLayout {
        break
      }
      layout = changedLayout
    }
    
    return String(layout.joined().filter { $0 == "#" }.count)
  }
  
  func part2(withInput input: String) -> String {
    var layout = input.lines().map { Array($0) }
    let seatLocs = makeSeatLocations(layout: layout)
    
    while true {
      let changedLayout = applyNewRules(to: layout, seatLocations: seatLocs)
      if layout == changedLayout {
        break
      }
      layout = changedLayout
    }
    
    return String(layout.joined().filter { $0 == "#" }.count)
  }
}

let testInput = """
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
"""

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day11()
var startTime = 0.0

print("====Test 1====")
let test1 = day.part1(withInput: testInput)
print(test1)

print("====Test 2====")
let test2 = day.part2(withInput: testInput)
print(test2)

print("====Part 1====")
startTime = CFAbsoluteTimeGetCurrent()
let part1 = day.part1(withInput: fileInput.raw)
print("result: \(part1), duration: \(CFAbsoluteTimeGetCurrent()-startTime)")

print("====Part 2====")
startTime = CFAbsoluteTimeGetCurrent()
let part2 = day.part2(withInput: fileInput.raw)
print("result: \(part2), duration: \(CFAbsoluteTimeGetCurrent()-startTime)")
