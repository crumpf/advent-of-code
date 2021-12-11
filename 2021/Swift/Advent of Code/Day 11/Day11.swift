//
//  Day11.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//
//  https://adventofcode.com/2021/day/11

import Foundation
import AppKit

class Day11: Day {
  func part1() -> String {
    var octoEnergy = makeOctopusEnergy()
    var sumFlashes = 0
    for _ in 1...100 {
      sumFlashes += octoEnergy.step().count
    }
    print("After 100 Steps")
    octoEnergy.printMap()
    
    return "\(sumFlashes)"
  }
  
  func part2() -> String {
    var octoEnergy = makeOctopusEnergy()
    for x in 1... {
      if octoEnergy.step().count == octoEnergy.map.count * octoEnergy.map[0].count {
        return "\(x)"
      }
    }
    return ""
  }
  
  func makeOctopusEnergy() -> OctopusEnergy {
    OctopusEnergy(map: input.lines().map { $0.compactMap { Int(String($0)) } })
  }
  
}

struct OctopusEnergy {
  var map: [[Int]]

  // returns locations that flashed
  mutating func step() -> [GridLocation] {
    for (row, rowEnergies) in map.enumerated() {
      for col in rowEnergies.indices {
        map[row][col] += 1
        if map[row][col] == 10 {
          flash(GridLocation(row: row, col: col))
        }
      }
    }
    var flashLocations: [GridLocation] = []
    for (row, rowEnergies) in map.enumerated() {
      for col in rowEnergies.indices {
        if map[row][col] > 9 {
          flashLocations.append(GridLocation(row: row, col: col))
          map[row][col] = 0
        }
      }
    }
    return flashLocations
  }
  
  private mutating func flash(_ loc: GridLocation) {
    for adjLoc in loc.surrounding() {
      if map.indices.contains(adjLoc.row) && map[adjLoc.row].indices.contains(adjLoc.col) {
        map[adjLoc.row][adjLoc.col] += 1
        if map[adjLoc.row][adjLoc.col] == 10 {
          flash(adjLoc)
        }
      }
    }
  }
  
  func printMap() {
    for row in map {
      print(row.reduce("") { $0 + String($1) })
    }
  }
}
