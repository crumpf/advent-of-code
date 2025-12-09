import Algorithms

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Point : Hashable {
    var x: Int
    var y: Int
  }

  var redTilePoints: [Point] {
    data.split(separator: "\n").map {
      let coords = $0.split(separator: ",")
      return Point(x: Int(coords[0])!, y: Int(coords[1])!)
    }
  }

  func part1() -> Any {
    let redTiles = redTilePoints
    var largestArea: Int = 0
    
    for i in redTiles.indices {
      for j in i+1..<redTiles.endIndex {
        let area = area(from: redTiles[i], to: redTiles[j])
        if area > largestArea {
          largestArea = area
        }
      }
    }

    return largestArea
  }

  func part2() -> Any {
    0
  }

  private func area(from: Point, to: Point) -> Int {
    (abs(to.x - from.x) + 1) * (abs(to.y - from.y) + 1)
  }
}
