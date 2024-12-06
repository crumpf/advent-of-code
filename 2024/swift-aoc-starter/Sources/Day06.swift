import Algorithms

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let grid = makeGrid()
    guard var patrol = grid.start else { return 0 }

    var dir = Dir.north
    var visited: Set<SIMD2<Int>> = []
    while grid.contains(patrol) {
      visited.insert(patrol)
      let next = patrol &+ dir.vector
      if let c = grid.char(at: next), c == "#" {
        dir = dir.turnRight()
      } else {
        patrol = next
      }
    }

    return visited.count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    0
  }

  func makeGrid() -> Grid {
    let grid = data.split(separator: "\n").map { Array($0) }
    return Grid(grid: grid)
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
    let grid: [[Character]]

    var start: SIMD2<Int>? {
      for (y, row) in grid.enumerated() {
        for (x, c) in row.enumerated() {
          if c == "^" { return SIMD2(x, y) }
        }
      }
      return nil
    }

    func dimensions() -> (x: Int, y: Int) { (x: grid[0].count, y: grid.count) }

    func char(at vertex: SIMD2<Int>) -> Character? {
      contains(vertex) ? grid[vertex.y][vertex.x] : nil
    }

    func contains(_ vertex: SIMD2<Int>) -> Bool {
      grid.indices.contains(vertex.y) && grid[0].indices.contains(vertex.x)
    }
  }
}
