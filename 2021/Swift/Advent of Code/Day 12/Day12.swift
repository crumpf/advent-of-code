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
    return ""
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
  
  func findPaths(in connections: [String: Set<String>]) -> [[String]] {
    let paths = explore(cave: "start", connections: connections, visited: [])
    return paths
  }
  
  func explore(cave: String, connections: [String: Set<String>], visited: [String]) -> [[String]] {
    guard let caves = connections[cave] else {
      return []
    }
    if (cave.lowercased() == cave) && visited.contains(cave) {
      return []
    }
    if cave == "end" {
      return [[cave]]
    }
    
    var explored: [[String]] = []
    for c in caves {
      explored += explore(cave: c, connections: connections, visited: visited + [cave])
    }
    return explored.map { [cave] + $0 }
  }
}

