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
    let quadrant: (SIMD2<Int>) -> Int? = {
      guard $0.x >= 0, $0.x < initialRobotData.width, $0.x != initialRobotData.width / 2,
            $0.y >= 0, $0.y < initialRobotData.height, $0.y != initialRobotData.height / 2
      else { return nil }
      return $0.y < initialRobotData.height / 2 ? ($0.x < initialRobotData.width / 2 ? 0 : 1) : ($0.x < initialRobotData.width / 2 ? 2 : 3)
    }
    return robots.reduce(into: Array(Array(repeating: 0, count: 4))) {
      if let q = quadrant($1.position) { $0[q] += 1 }
    }
    .reduce(1, *)
  }

  func part2() -> Any {
    0
  }
  
  func nextVector(from vector: Vector, withinWidth width: Int, height: Int) -> Vector {
    var pos = vector.position &+ vector.velocity
    if pos.x < 0 { pos.x = width + pos.x % width }
    else if pos.x >= width { pos.x = pos.x % width }
    if pos.y < 0 { pos.y = height + pos.y % height }
    else if pos.y >= height { pos.y = pos.y % height }
    return Vector(position: pos, velocity: vector.velocity)
  }
  
  struct Vector {
    let position: SIMD2<Int>
    let velocity: SIMD2<Int>
  }
}
