import Algorithms

struct Day16: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func makeMaze() -> Maze {
    Maze(map: data.split(separator: "\n").map(Array.init))
  }

  func part1() -> Any {
    let maze = makeMaze()
    let start = maze.firstLocation(of: "S")!
    let end = maze.firstLocation(of: "E")!
    let path = DijkstraSearch.findPath(
      from: Maze.Node(location: start, heading: .east),
      isDestination: { vertex in
        vertex.location == end
      },
      in: maze)
    return path!.cost
  }

  func part2() -> Any {
    0
  }

  struct Maze: WeightedPathfinding {
    let map: [[Character]]

    func dimensions() -> (width: Int, height: Int) { (map[0].count, map.count) }

    func char(at point: SIMD2<Int>) -> Character? {
      contains(point) ? map[point.y][point.x] : nil
    }

    func contains(_ point: SIMD2<Int>) -> Bool {
      map.indices.contains(point.y) && map[0].indices.contains(point.x)
    }

    func firstLocation(of value: Character) -> SIMD2<Int>? {
      for (y, row) in map.enumerated() { for (x, c) in row.enumerated() { if c == value { return SIMD2(x, y) } } }
      return nil
    }

    enum Heading {
      case north, east, south, west

      var vector: SIMD2<Int> {
        switch self {
        case .north:
          return SIMD2(0, -1)
        case .east:
          return SIMD2(1, 0)
        case .south:
          return SIMD2(0, 1)
        case .west:
          return SIMD2(-1, 0)
        }
      }
    }

    struct Node: Hashable {
      let location: SIMD2<Int>
      let heading: Heading
    }

    // Pathfinding protocols

    typealias Cost = Int
    typealias Vertex = Node

    func cost(from: Node, to: Node) -> Int {
      guard from != to else { return 0 }
      return from.heading == to.heading ? 1 : 1001
    }

    func neighbors(for vertex: Node) -> [Node] {
      let headings: [Heading]
      switch vertex.heading {
      case .north: headings = [.north, .east, .west]
      case .east: headings = [.east, .south, .north]
      case .south: headings = [.south, .west, .east]
      case .west: headings = [.west, .north, .south]
      }
      return headings.map { Node(location: vertex.location &+ $0.vector, heading: $0) }.filter
      { if let c = char(at: $0.location), c != "#" { return true } else { return false } }
    }
  }
}
