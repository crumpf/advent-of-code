//
//  Day15.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//
//  https://adventofcode.com/2021/day/15

import Foundation

class Day15: Day {
  func part1() -> String {
    let lowestRiskTotal = lowestTotalRiskOfAnyPath(in: makeRiskMap())
    return "\(lowestRiskTotal ?? -1)"
  }
  
  func part2() -> String {
    let lowestRiskTotal = lowestTotalRiskOfAnyPath(in: makeBigRiskMap())
    return "\(lowestRiskTotal ?? -1)"
  }
  
  func makeRiskMap() -> [[Int]] {
    input.lines().map { $0.compactMap { Int(String($0)) } }
  }
  
  func makeBigRiskMap() -> [[Int]] {
    let map = makeRiskMap()
    var bigmap = map
    for n in map.indices {
      for inc in 1...4 {
        bigmap[n] += map[n].map {
          $0 + inc < 10 ? $0 + inc : ($0 + inc) % 9
        }
      }
    }
    for inc in 1...4 {
      for n in map.indices {
        bigmap.append(bigmap[n].map {
          $0 + inc < 10 ? $0 + inc : ($0 + inc) % 9
        })
      }
    }
    return bigmap
  }
  
  typealias Vertex2D = SIMD2<Int>
  typealias Visit = (from: TreeNode<Vertex2D>, risk: Int)
  
  // Find the path to the end with the lowest risk. I'll use Dijkstra’s algorithm.
  func lowestTotalRiskOfAnyPath(in riskMap: [[Int]]) -> Int? {
    guard let maxX = riskMap.first?.indices.last,
          let maxY = riskMap.indices.last
    else {
      return nil
    }
    let vertRange = riskMap.indices
    let horzRange = riskMap[0].indices
    
    let start = Vertex2D(0, 0)
    let end = Vertex2D(maxX, maxY)
    let tree = TreeNode(element: start) // tree root begins at vertex 0
    var result: Visit?
    var verticiesSeen = Set([start])
    var toVisit: [Vertex2D: Visit] = [Vertex2D(1, 0): Visit(from:tree, risk:riskMap[0][1]),
                                      Vertex2D(0, 1): Visit(from:tree, risk:riskMap[1][0])]
    
    while !verticiesSeen.contains(end) {
      // look at the next shortest
      guard let min = toVisit.min(by: { $0.value.risk < $1.value.risk }) else {
        return nil
      }
      toVisit.removeValue(forKey: min.key)
      verticiesSeen.insert(min.key)
      let node = TreeNode(element: min.key)
      min.value.from.add(child: node)
      if end != min.key {
        orthogonalAdjacents(to: min.key)
          .filter { adj in
            !verticiesSeen.contains(adj) && horzRange.contains(adj.x) && vertRange.contains(adj.y)
          }
          .forEach {
            let newRisk = min.value.risk + riskMap[$0.y][$0.x]
            let v = toVisit[$0]
            if v == nil || newRisk < v!.risk {
              toVisit[$0] = Visit(from: node, risk: newRisk)
            }
          }
      } else {
        result = Visit(from:node, risk:min.value.risk)
      }
    }
//    printToRoot(from: result?.from)
    return result?.risk
  }
  
  func orthogonalAdjacents(to point: Vertex2D) -> [Vertex2D] {
      [Vertex2D(-1, 0), Vertex2D(0, 1), Vertex2D(1, 0), Vertex2D(0, -1)].map { point &+ $0 }
  }
  
  func printToRoot(from node: TreeNode<Vertex2D>?) {
    var n = node
    while n != nil {
      print(String(describing: n?.element))
      n = n?.parent
    }
  }
  
}
