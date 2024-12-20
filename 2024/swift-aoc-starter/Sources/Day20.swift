import Algorithms

struct Day20: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func part1() -> Any {
    cheatsSaving(atLeast: 100)
  }

  func part2() -> Any {
    0
  }

  func cheatsSaving(atLeast: Int) -> Int {
    let racetrack = Racetrack(data: data)
    let start = racetrack.firstLocation(of: "S")!
    let end = racetrack.firstLocation(of: "E")!
    var cheats = 0
    guard let bestFairPath = DijkstraSearch.findPath(from: Racetrack.Vertex(location: start), to: Racetrack.Vertex(location: end), in: racetrack) else {
      return 0
    }

    let walls = racetrack.map.enumerated()
      .compactMap { (y, row) in
        row.enumerated().compactMap {
          return $0.element == "#" ? SIMD2($0.offset, y) : nil
        }
      }
      .flatMap { $0 }
    // this is brutish but gets the job done. should revisit and optimize.
    walls.forEach { wall in
      let cheatPath = DijkstraSearch.findPath(
        from: Racetrack.Vertex(location: start),
        neighbors: { node in
          Racetrack.Direction.allCases.compactMap {
            let adj = node.vertex.location &+ $0.vector
            guard let elem = racetrack.value(at: adj) else { return nil }
            if elem == "#" {
              return adj == wall ? Racetrack.Vertex(location: adj, cheat: true) : nil
            } else {
              return Racetrack.Vertex(location: adj)
            }
          }
        }, isDestination: { node in
          node.vertex.location == end
        }, in: racetrack)

      if let cheatPath, bestFairPath.cost - cheatPath.cost >= atLeast {
        cheats += 1
      }
    }

    return cheats
  }

  struct Racetrack: WeightedPathfinding {
    init(data: String) {
      map = data.split(separator: "\n").map(Array.init)
    }

    let map: [[Character]]

    func dimensions() -> (width: Int, height: Int) { (map[0].count, map.count) }

    func value(at point: SIMD2<Int>) -> Character? {
      contains(point) ? map[point.y][point.x] : nil
    }

    func contains(_ point: SIMD2<Int>) -> Bool {
      map.indices.contains(point.y) && map[0].indices.contains(point.x)
    }

    func firstLocation(of value: Character) -> SIMD2<Int>? {
      for (y, row) in map.enumerated() { for (x, elem) in row.enumerated() { if elem == value { return SIMD2(x, y) } } }
      return nil
    }

    enum Direction: CaseIterable {
      case up, right, down, left

      var vector: SIMD2<Int> {
        switch self {
        case .up:
          return SIMD2(0, -1)
        case .right:
          return SIMD2(1, 0)
        case .down:
          return SIMD2(0, 1)
        case .left:
          return SIMD2(-1, 0)
        }
      }
    }

    struct Node: Hashable {
      let location: SIMD2<Int>
      var cheat: Bool = false
    }

    // Pathfinding protocols

    typealias Cost = Int
    typealias Vertex = Node

    func cost(from: Node, to: Node) -> Int {
      guard from != to else { return 0 }
      return 1
    }

    func neighbors(for vertex: Node) -> [Node] {
      Direction.allCases.compactMap {
        let nextLocation = vertex.location &+ $0.vector
        guard let value = value(at: nextLocation), value != "#" else {
          return nil
        }
        return Node(location: nextLocation)
      }
    }
  }
}
