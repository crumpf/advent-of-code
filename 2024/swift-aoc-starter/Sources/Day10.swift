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
    return topoMap.trailheads().map { topoMap.score(trailhead: $0) }.reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let topoMap = makeTopoMap()
    return topoMap.trailheads().map { topoMap.rating(trailhead: $0) }.reduce(0, +)
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
    
    func trailheads() -> [Vertex] {
      var trailheads: [Vertex] = []
      for y in map.indices {
        for x in map[0].indices {
          if map[y][x] == 0 { trailheads.append(Vertex(x, y)) }
        }
      }
      return trailheads
    }
    
    func neighbors(for vertex: Vertex) -> [Vertex] {
      guard let height = value(at: vertex) else { return [] }
      return [Vertex(0,-1), Vertex(0,1), Vertex(-1,0), Vertex(1,0)].map { vertex &+ $0 }
        .filter {
          if let adjHeight = value(at: $0), adjHeight - height == 1 { return true }
          return false
        }
    }

    // A trailhead's `score` is the number of 9-height positions reachable from that trailhead via a hiking trail
    func score(trailhead: Vertex) -> Int {
      var summitsReached: Set<TopoMap.Vertex> = []
      findPathsToSummits(from: trailhead, summitReached: { path in
        summitsReached.insert(path.vertex)
      })
      return summitsReached.count
    }

    // A trailhead's `rating` is the number of distinct hiking trails which begin at that trailhead
    func rating(trailhead: Vertex) -> Int {
      var distinctTrails = 0
      findPathsToSummits(from: trailhead, summitReached: { path in
        distinctTrails += 1
      })
      return distinctTrails
    }

    // This is a BFS search but doesn't use a set of explored nodes to find shortest path like a normal BFS.
    // The topo map is a directed graph so it shouldn't produce cycles. It should find all paths to summits (height == 9).
    func findPathsToSummits(from start: Vertex, summitReached: (PathNode<Vertex>) -> Void) {
      var frontier = Queue<PathNode<Vertex>>()
      frontier.enqueue(PathNode(vertex: start))
      while let currentNode = frontier.dequeue() {
        if let height = value(at: currentNode.vertex), height == 9 {
          summitReached(currentNode)
        }
        for successor in neighbors(for: currentNode.vertex) {
          frontier.enqueue(PathNode(vertex: successor, predecessor: currentNode))
        }
      }
    }
  }

}
