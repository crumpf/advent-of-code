import Algorithms

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    makeGrid().visitedVerticies.count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let grid = makeGrid()
    guard let start = grid.start else { return 0 }

    var obstacles: Set<SIMD2<Int>> = []

    // try placing obstacles and seeing if we create a cycle as a result
    for possibleObstacle in grid.visitedVerticies {
      var pos = DirectionalPosition(vertex: start, dir: .north)
      var visited: Set<DirectionalPosition> = []
      while grid.contains(pos.vertex) {
        if visited.contains(pos) {
          obstacles.insert(possibleObstacle)
          break
        } else {
          visited.insert(pos)
        }
        let next = DirectionalPosition(vertex: pos.vertex &+ pos.dir.vector, dir: pos.dir)
        if let c = grid.char(at: next.vertex), c == "#" || next.vertex == possibleObstacle {
          pos = DirectionalPosition(vertex: pos.vertex, dir: pos.dir.turnRight())
        } else {
          pos = next
        }
      }
    }

    return obstacles.count
  }

  func makeGrid() -> Grid {
    let grid = data.split(separator: "\n").map { Array($0) }
    return Grid(map: grid)
  }

  struct DirectionalPosition: Hashable {
    let vertex: SIMD2<Int>
    let dir: Dir
  }

  enum Dir {
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

    func turnRight() -> Dir {
      switch self {
      case .north:
        return .east
      case .east:
        return .south
      case .south:
        return .west
      case .west:
        return .north
      }
    }
  }

  struct Grid {
    let map: [[Character]]

    var start: SIMD2<Int>? {
      for (y, row) in map.enumerated() {
        for (x, c) in row.enumerated() {
          if c == "^" { return SIMD2(x, y) }
        }
      }
      return nil
    }

    var visitedVerticies: Set<SIMD2<Int>> {
      guard var patrol = start else { return [] }

      var dir = Dir.north
      var visited: Set<SIMD2<Int>> = []
      while contains(patrol) {
        visited.insert(patrol)
        let next = patrol &+ dir.vector
        if let c = char(at: next), c == "#" {
          dir = dir.turnRight()
        } else {
          patrol = next
        }
      }

      return visited
    }

    func dimensions() -> (width: Int, height: Int) { (map[0].count, map.count) }

    func char(at vertex: SIMD2<Int>) -> Character? {
      contains(vertex) ? map[vertex.y][vertex.x] : nil
    }

    func contains(_ vertex: SIMD2<Int>) -> Bool {
      map.indices.contains(vertex.y) && map[0].indices.contains(vertex.x)
    }
  }
}
