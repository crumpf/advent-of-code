import Algorithms

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  fileprivate var grid: Grid {
    data.split(separator: "\n").map { Array($0) }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let g = grid
    var result = 0
    for (y, row) in g.enumerated() {
      for (x, c) in row.enumerated(){
        if c == "X" {
          result += vectors.map {
            $0.map { SIMD2(x, y) &+ $0 }
          }
          .filter {
            $0.compactMap { g.contains($0) ? g.char(at: $0) : nil } == ["X", "M", "A", "S"]
          }
          .count
        }
      }
    }
    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    0
  }

  static let north = [SIMD2(0, 0), SIMD2(0, -1), SIMD2(0, -2), SIMD2(0, -3)],
             west = [SIMD2(0, 0), SIMD2(-1, 0), SIMD2(-2, 0), SIMD2(-3, 0)],
             south = [SIMD2(0, 0), SIMD2(0, 1), SIMD2(0, 2), SIMD2(0, 3)],
             east = [SIMD2(0, 0), SIMD2(1, 0), SIMD2(2, 0), SIMD2(3, 0)]

  var vectors: [[SIMD2<Int>]] {
    [Self.north, zip(Self.north, Self.west).map(&+), Self.west, zip(Self.south, Self.west).map(&+),
     Self.south, zip(Self.south, Self.east).map(&+), Self.east, zip(Self.north, Self.east).map(&+),]
  }
}

fileprivate typealias Grid = [[Character]]

fileprivate extension Grid {
  func dimensions() -> (x: Int, y: Int) { (x: self[0].count, y: count) }

  func char(at vertex: SIMD2<Int>) -> Character { self[vertex.y][vertex.x] }

  func contains(_ vertex: SIMD2<Int>) -> Bool {
    vertex.y >= 0 && vertex.y < count && vertex.x >= 0 && vertex.x < self[0].count
  }
}
