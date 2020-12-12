//
//  Day3.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

struct Cartesian { var x, y: Int }
struct Slope { let right, down: Int }

class Day3: Day {
  /// Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?
  func part1() -> String {
    let map = grid()
    let start = Cartesian(x: 0, y: 0)
    let slope = Slope(right: 3, down: 1)
    let treeCount = treesInPath(map: map, start: start, slope: slope)
    
    return String(describing: treeCount)
  }
  
  /// What do you get if you multiply together the number of trees encountered on each of the listed slopes?
  func part2() -> String {
    let map = grid()
    let start = Cartesian(x: 0, y: 0)
    let slopes = [
      Slope(right: 1, down: 1),
      Slope(right: 3, down: 1),
      Slope(right: 5, down: 1),
      Slope(right: 7, down: 1),
      Slope(right: 1, down: 2) ]
    
    var hit: [Int] = []
    for slope in slopes {
      hit.append(treesInPath(map: map, start: start, slope: slope))
    }
    
    let result = hit.reduce(1) { $0 * $1 }
    return String(describing: result)
  }
  
  private func grid() -> [[Character]] {
    input.lines().map { Array($0) }
  }
  
  private func treesInPath(map: [[Character]], start: Cartesian, slope: Slope) -> Int {
    var location = start
    var treesHit = 0
    
    for y in stride(from: location.y, to: map.endIndex, by: slope.down) {
      let row = map[y]
      if row[location.x % row.count] == "#" {
        treesHit += 1
      }
      
      location.x += slope.right
      location.y = y
    }
    
    return treesHit
  }
}
