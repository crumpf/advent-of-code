import Algorithms

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Point : Hashable {
    var x: Int
    var y: Int

    func area(to: Point) -> Int {
      (abs(to.x - x) + 1) * (abs(to.y - y) + 1)
    }
  }

  struct Rect : Hashable {
    let p1: Point
    let p2: Point
    let area: Int

    init(p1: Point, p2: Point) {
      self.p1 = p1
      self.p2 = p2
      self.area = p1.area(to: p2)
    }

    func doesPerimiterCrossSegment(from a: Point, to b: Point) -> Bool {
      let segX = min(a.x, b.x) ... max(a.x, b.x)
      let segY = min(a.y, b.y) ... max(a.y, b.y)
      // shave of area because the area has to fully cross the edge segments
      let horz = (min(p1.x, p2.x) + 1) ... (max(p1.x, p2.x) - 1)
      let vert = (min(p1.y, p2.y) + 1) ... (max(p1.y, p2.y) - 1)

      return segX.overlaps(horz) && segY.overlaps(vert)
    }
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
        let area = redTiles[i].area(to: redTiles[j])
        if area > largestArea {
          largestArea = area
        }
      }
    }

    return largestArea
  }

  func part2() -> Any {
    let redTiles = redTilePoints
    let sortedRects = redTiles.enumerated().flatMap { i, tile in
      redTiles[i+1..<redTiles.endIndex].map { otherTile in
        Rect(p1: tile, p2: otherTile)
      }
    }
      .sorted { a, b in
        a.area > b.area
      }
    let perimeterSegments = Array(zip(redTiles, redTiles.dropFirst())) + [(redTiles.last!, redTiles.first!)]

    for rect in sortedRects {
      // check to see if the edges of the rect cross any line segments from our red tile data which are the perimeter coordinates
      let noOverlaps = perimeterSegments.allSatisfy { (a, b) in
        !rect.doesPerimiterCrossSegment(from: a, to: b)
      }
      if noOverlaps {
        return rect.area
      }
    }

    return sortedRects[0].area
  }

}
