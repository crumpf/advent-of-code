import Algorithms

struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func makeTopoMap() -> TopoMap {
    let map = data.split(separator: "\n").map { Array($0).map(\.wholeNumberValue!) }
    return TopoMap(map: map)
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let topoMap = makeTopoMap()
    let trails = topoMap.trailheadsAndSummits()
    return trails.trailheads.map {
      var summitsReached: Set<TopoMap.Vertex> = []
      _ = topoMap.findPath(from: $0, isDestination: { vertex in
        if let height = topoMap.value(at: vertex), height == 9 {
          summitsReached.insert(vertex)
          if summitsReached.count == trails.summits.count {
            return true
          }
        }
        return false
      })
      return summitsReached.count
    }
    .reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let topoMap = makeTopoMap()
    let trails = topoMap.trailheadsAndSummits()
    return trails.trailheads.map {
      var distinctTrails = 0
      _ = topoMap.findPath(from: $0, isDestination: { vertex in
        if let height = topoMap.value(at: vertex), height == 9 {
          distinctTrails += 1
        }
        return false
      }, findShortest: false)
      return distinctTrails
    }
    .reduce(0, +)
  }
  
  struct TopoMap {
    typealias Vertex = SIMD2<Int>

    let map: [[Int]]

    func dimensions() -> (width: Int, height: Int) { (map[0].count, map.count) }

    func value(at vertex: Vertex) -> Int? {
      contains(vertex) ? map[vertex.y][vertex.x] : nil
    }

    func contains(_ vertex: Vertex) -> Bool {
      map.indices.contains(vertex.y) && map[0].indices.contains(vertex.x)
    }
    
    func trailheadsAndSummits() -> (trailheads: [Vertex], summits: [Vertex]) {
      var trailheads: [Vertex] = []
      var summits: [Vertex] = []
      for y in map.indices {
        for x in map[0].indices {
          if map[y][x] == 0 { trailheads.append(Vertex(x, y)) }
          else if map[y][x] == 9 { summits.append(Vertex(x, y)) }
        }
      }
      return (trailheads, summits)
    }
    
    func neighbors(for vertex: Vertex) -> [Vertex] {
      guard let height = value(at: vertex) else { return [] }
      return [Vertex(0,-1), Vertex(0,1), Vertex(-1,0), Vertex(1,0)].map { vertex &+ $0 }
        .filter {
          if let adjHeight = value(at: $0), adjHeight - height == 1 { return true }
          return false
        }
    }

    // BFS search, `findShortest = false` disables using set of explored nodes to find shortest path.
    // Theh topo map is a directed graph so it shouldn't produce cycles
    func findPath(from start: Vertex, isDestination: (Vertex) -> Bool, findShortest: Bool = true) -> PathNode<Vertex>? {
      var frontier = Queue<PathNode<Vertex>>()
      frontier.enqueue(PathNode(vertex: start))
      var explored: Set<Vertex> = [start]
      while let currentNode = frontier.dequeue() {
        if isDestination(currentNode.vertex) {
          return currentNode
        }
        if findShortest {
          for successor in neighbors(for: currentNode.vertex) where !explored.contains(successor) {
            explored.insert(successor)
            frontier.enqueue(PathNode(vertex: successor, predecessor: currentNode))
          }
        } else {
          for successor in neighbors(for: currentNode.vertex) {
            frontier.enqueue(PathNode(vertex: successor, predecessor: currentNode))
          }
        }
      }
      return nil
    }
  }

}
