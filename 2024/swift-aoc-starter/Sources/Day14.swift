import Algorithms

struct Day14: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  func parseData() -> (vectors: [Vector], width: Int, height: Int) {
    let vectors = data.matches(of: /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/).map {
      let (_, px, py, vx, vy) = $0.output
      return Vector(position: SIMD2(Int(px)!, Int(py)!), velocity: SIMD2(Int(vx)!, Int(vy)!))
    }
    if vectors.count == 12 {
      // the test input has 12 robots and are in a space which is only 11 tiles wide and 7 tiles tall
      return (vectors, 11, 7)
    }
    return (vectors, 101, 103)
  }

  func part1() -> Any {
    let initialRobotData = parseData()
    var robots = initialRobotData.vectors
    for _ in 1...100 {
      for index in robots.indices {
        robots[index] = nextVector(from: robots[index], withinWidth: initialRobotData.width, height: initialRobotData.height)
      }
    }
    return robots.reduce(into: Array(repeating: 0, count: 4)) {
      if let q = quadrant(of: $1.position, withinWidth: initialRobotData.width, height: initialRobotData.height) {
        $0[q] += 1
      }
    }
    .reduce(1, *)
  }

  func part2() -> Any {
    let initialRobotData = parseData()
    var robots = initialRobotData.vectors
    for t in 1...100_000 {
      for index in robots.indices {
        robots[index] = nextVector(from: robots[index], withinWidth: initialRobotData.width, height: initialRobotData.height)
      }
      // There's an easter egg in here somewhere. I'm taking a wild-ass guess that it's a large contiguous
      // region in the center of the map.
      // The horrible assumption here is that I'm guessing that 1) any contiguous group > 100 is what we're
      // looking for and 2) that it touches the center.
      // At least for my input those assumptions held, but I was lucky that the frame or the hidden
      // tree image was on the center and not the tree itself. I should revisit this with a more
      // correct solution.
      let seed = SIMD2(initialRobotData.width / 2, initialRobotData.height / 2)
      let region = self.region(from: seed, positions: Set(robots.map { $0.position}) )
      if region.count > 100 {
        print("time \(t) count: \(region.count)")
        let xsorted = region.sorted(by: {$0.x < $1.x})
        let ysorted = region.sorted(by: {$0.y < $1.y})
        for y in ysorted.first!.y...ysorted.last!.y {
          var row = ""
          for x in xsorted.first!.x...xsorted.last!.x {
            row += Set(robots.map { $0.position }).contains(SIMD2(x, y)) ? "#" : "."
          }
          print(row)
        }
        return t
      }
    }
    
    return -1
  }
  
  func nextVector(from vector: Vector, withinWidth width: Int, height: Int) -> Vector {
    var pos = vector.position &+ vector.velocity
    if pos.x < 0 { pos.x = width + pos.x % width }
    else if pos.x >= width { pos.x = pos.x % width }
    if pos.y < 0 { pos.y = height + pos.y % height }
    else if pos.y >= height { pos.y = pos.y % height }
    return Vector(position: pos, velocity: vector.velocity)
  }
  
  func quadrant(of v: SIMD2<Int>, withinWidth width: Int, height: Int) -> Int? {
    guard v.x >= 0, v.x < width, v.x != width / 2,
          v.y >= 0, v.y < height, v.y != height / 2
    else { return nil }
    return v.y < height / 2 ? (v.x < width / 2 ? 0 : 1) : (v.x < width / 2 ? 2 : 3)
  }
  
  struct Vector {
    let position: SIMD2<Int>
    let velocity: SIMD2<Int>
  }
  
  func region(from start: SIMD2<Int>, positions: Set<SIMD2<Int>>) -> Set<SIMD2<Int>> {
    var frontier = Queue<SIMD2<Int>>()
    frontier.enqueue(start)
    var explored: Set<SIMD2<Int>> = [start]
    while let currentNode = frontier.dequeue() {
      let neighbors = [SIMD2(1,0), SIMD2(0,1), SIMD2(-1,0), SIMD2(0,-1)]
        .map { currentNode &+ $0 }
        .filter { positions.contains($0) }
      for successor in neighbors where !explored.contains(successor) {
        explored.insert(successor)
        frontier.enqueue(successor)
      }
    }
    return explored
  }

}
