//
//  Day12.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day12: Day {
  func part1() -> String {
    let caveConnections = makeCaveConnections()
    let paths = findPaths(in: caveConnections)
    return "\(paths.count)"
  }
  
  func part2() -> String {
    let caveConnections = makeCaveConnections()
    let paths = findPaths(in: caveConnections, canVisitSmallTwice: true)
    return "\(paths.count)"
  }
  
  func makeCaveConnections() -> [String: Set<String>] {
    var connections: [String: Set<String>] = [:]
    for line in input.lines() {
      let parts = line.components(separatedBy: "-")
      if let _ = connections[parts[0]] {
        connections[parts[0]]?.insert(parts[1])
      } else {
        connections[parts[0]] = [parts[1]]
      }
      if let _ = connections[parts[1]] {
        connections[parts[1]]?.insert(parts[0])
      } else {
        connections[parts[1]] = [parts[0]]
      }
    }
    return connections
  }
  
  func findPaths(in connections: [String: Set<String>], canVisitSmallTwice: Bool = false) -> [[String]] {
    let paths = explore(cave: "start", connections: connections, visited: [], canVisitSmallTwice: canVisitSmallTwice)
    return paths
  }
  
  func explore(cave: String, connections: [String: Set<String>], visited: [String], canVisitSmallTwice: Bool = false) -> [[String]] {
    guard let caves = connections[cave] else {
      return []
    }
    if cave == "start" && visited.contains(cave) {
      return []
    }
    var smallVisitAgain = canVisitSmallTwice
    if cave.lowercased() == cave && visited.contains(cave) {
      if smallVisitAgain {
        smallVisitAgain = false
      } else {
        return []
      }
    }
    if cave == "end" {
      return [[cave]]
    }
    
    var explored: [[String]] = []
    for c in caves {
      explored += explore(cave: c, connections: connections, visited: visited + [cave], canVisitSmallTwice: smallVisitAgain)
    }
    return explored.map { [cave] + $0 }
  }
}

