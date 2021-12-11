//
//  Day11.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//
//  https://adventofcode.com/2021/day/11

import Foundation
import AppKit

typealias OctopusEnergyMap = [[Int]]

class Day11: Day {
  func part1() -> String {
    var energies = makeOctopusEnergyMap()
    var sumFlashes = 0
    for _ in 1...100 {
      sumFlashes += energies.step().count
    }
    print("After 100 Steps")
    energies.printMap()
    
    return "\(sumFlashes)"
  }
  
  func part2() -> String {
    var energies = makeOctopusEnergyMap()
    for x in 1... {
      if energies.step().count == energies.count * energies[0].count {
        return "\(x)"
      }
    }
    return ""
  }
  
  func makeOctopusEnergyMap() -> OctopusEnergyMap {
    input.lines().map { $0.compactMap { Int(String($0)) } }
  }
  
}

extension OctopusEnergyMap {
  // returns locations that flashed
  mutating func step() -> [GridLocation] {
    for (row, rowEnergies) in self.enumerated() {
      for col in rowEnergies.indices {
        self[row][col] += 1
        if self[row][col] == 10 {
          flash(GridLocation(row: row, col: col))
        }
      }
    }
    var flashLocations: [GridLocation] = []
    for (row, rowEnergies) in self.enumerated() {
      for col in rowEnergies.indices {
        if self[row][col] > 9 {
          flashLocations.append(GridLocation(row: row, col: col))
          self[row][col] = 0
        }
      }
    }
    return flashLocations
  }
  
  private mutating func flash(_ loc: GridLocation) {
    for adjLoc in loc.surrounding() {
      if self.indices.contains(adjLoc.row) && self[adjLoc.row].indices.contains(adjLoc.col) {
        self[adjLoc.row][adjLoc.col] += 1
        if self[adjLoc.row][adjLoc.col] == 10 {
          flash(adjLoc)
        }
      }
    }
  }
  
  func printMap() {
    for row in self {
      print(row.reduce("") { $0 + String($1) })
    }
  }
}
