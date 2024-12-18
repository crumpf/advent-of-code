import Algorithms

struct Day18: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var incomingBytePositions: [SIMD2<Int>] {
    data.matches(of: /(\d+),(\d+)/).map {
      let (_, x, y) = $0.output
      return SIMD2(Int(x)!, Int(y)!)
    }
  }

  func part1() -> Any {
    part1MinimumStepsToReachExit(width: 71, height: 71, numberCorrupted: 1024)
  }

  func part2() -> Any {
    part2FirstByteThatPreventsTheExitFromBeingReachable(width: 71, height: 71)
  }

  func part1MinimumStepsToReachExit(width: Int, height: Int, numberCorrupted: Int) -> Any {
    let maze = Maze(corruptedLocations: Set(incomingBytePositions[0..<numberCorrupted]), width: width, height: height)
    let path = BreadthFirstSearch.findPath(from: SIMD2.zero, to: SIMD2(width-1, height-1), in: maze)
    var steps = 0
    path?.iteratePath(body: { i, node, stop in
      steps = i
    })
    return steps
  }

  func part2FirstByteThatPreventsTheExitFromBeingReachable(width: Int, height: Int) -> Any {
    let corruptedLocations = incomingBytePositions
    for (offset, location) in corruptedLocations.enumerated() {
      let maze = Maze(corruptedLocations: Set(corruptedLocations[0...offset]), width: width, height: height)
      let path = BreadthFirstSearch.findPath(from: SIMD2.zero, to: SIMD2(width-1, height-1), in: maze)
      if path == nil {
        return "\(location.x),\(location.y)"
      }
    }
    return "none"
  }

  struct Maze: Pathfinding {
    let corruptedLocations: Set<SIMD2<Int>>
    let width, height: Int

    func value(at point: SIMD2<Int>) -> Character? {
      guard contains(point) else { return nil }
      return corruptedLocations.contains(point) ? "#" : "."
    }

    func contains(_ point: SIMD2<Int>) -> Bool {
      (0..<height).contains(point.y) && (0..<width).contains(point.x)
    }

    enum Direction {
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

    // Pathfinding protocols

    typealias Vertex = SIMD2<Int>

    func neighbors(for vertex: Vertex) -> [Vertex] {
      [Direction.right, Direction.down, Direction.left, Direction.up]
        .map { vertex &+ $0.vector }
        .filter {
          if let c = value(at: $0), c != "#" { return true } else { return false }
        }
    }
  }

}
