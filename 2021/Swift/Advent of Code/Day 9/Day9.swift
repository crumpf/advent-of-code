//
//  Day9.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

typealias HeightMap = [[Int]]

class Day9: Day {
  func part1() -> String {
    let lowPoints: [GridLocation] = heightmap.lowPoints()
    let risk = lowPoints.reduce(0) { $0 + (heightmap[$1.row][$1.col] + 1) }
    return "\(risk)"
  }
  
  func part2() -> String {
    let basins = heightmap.basins()
    let result = basins.sorted { $0.locations.count > $1.locations.count } [0..<3]
      .reduce(1) {
        $0 * $1.locations.count
      }
    return "\(result)"
  }
  
  private(set) lazy var heightmap: HeightMap = input.lines().map { $0.compactMap { Int(String($0)) } }
}

struct Basin {
  let lowPoint: GridLocation
  let locations: Set<GridLocation>
}

extension HeightMap {
  func lowPoints() -> [GridLocation] {
    var lowPoints: [GridLocation] = []
    self.enumerated().forEach { row in
      row.element.enumerated().forEach { col in
        let adjacentIndexes = GridLocation(row: row.offset, col: col.offset).orthogonal()
        let isLowest = nil == adjacentIndexes.first {
          self.indices.contains($0.row)
          && row.element.indices.contains($0.col)
          && self[$0.row][$0.col] <= col.element
        }
        if isLowest {
          lowPoints.append(GridLocation(row: row.offset, col: col.offset))
        }
      }
    }
    return lowPoints
  }
  
  func basins() -> ([Basin]) {
    var basins: [Basin] = []
    let lows = lowPoints()
    lows.forEach { lowPt in
      var basinPts: Set<GridLocation> = []
      growBasin(from: lowPt, basinPoints: &basinPts)
      basins.append(Basin(lowPoint: lowPt, locations: basinPts))
    }
    return basins
  }
  
  private func growBasin(from loc: GridLocation, basinPoints: inout Set<GridLocation>) {
    if !basinPoints.contains(loc) && isBasinLocation(loc)  {
      basinPoints.insert(loc)
      loc.orthogonal().forEach { growBasin(from: $0, basinPoints: &basinPoints) }
    }
  }
  
  private func isBasinLocation(_ loc: GridLocation) -> Bool {
    self.indices.contains(loc.row)
    && self[loc.row].indices.contains(loc.col)
    && self[loc.row][loc.col] < 9
  }
}
