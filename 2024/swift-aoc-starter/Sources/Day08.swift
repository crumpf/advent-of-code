import Algorithms

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func makeGrid() -> Grid {
    Grid(map: data.split(separator: "\n").map { Array($0) })
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let grid = makeGrid()
    let antennas = grid.map.enumerated().reduce(into: [Character: Set<Grid.Vertex>]()) { map, row in
      for (x, c) in row.element.enumerated() {
        if c != "." {
          let vertex = Grid.Vertex(x, row.offset)
          if map[c] != nil { map[c]?.insert(vertex) } else { map[c] = [vertex] }
        }
      }
    }
    let antinodes = antennas.reduce(into: Set<Grid.Vertex>()) { set, elem in
      let verticies = Array(elem.value)
      for offset in (1..<verticies.count) {
        let v1 = verticies[offset-1]
        for v2 in verticies.dropFirst(offset) {
          var antinode = v1 &+ (v1 &- v2)
          if grid.contains(antinode) { set.insert(antinode)}
          antinode = v2 &+ (v2 &- v1)
          if grid.contains(antinode) { set.insert(antinode)}
        }
      }
    }
    return antinodes.count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let grid = makeGrid()
    let antennas = grid.map.enumerated().reduce(into: [Character: Set<Grid.Vertex>]()) { map, row in
      for (x, c) in row.element.enumerated() {
        if c != "." {
          let vertex = Grid.Vertex(x, row.offset)
          if map[c] != nil { map[c]?.insert(vertex) } else { map[c] = [vertex] }
        }
      }
    }
    let antinodes = antennas.reduce(into: Set<Grid.Vertex>()) { set, elem in
      let verticies = Array(elem.value)
      for offset in (1..<verticies.count) {
        let v1 = verticies[offset-1]
        for v2 in verticies.dropFirst(offset) {
          var antinode = v1
          var vector = v1 &- v2
          while grid.contains(antinode) {
            set.insert(antinode)
            antinode &+= vector
          }
          antinode = v2
          vector = v2 &- v1
          while grid.contains(antinode) {
            set.insert(antinode)
            antinode &+= vector
          }
        }
      }
    }
    return antinodes.count
  }

  struct Grid {
    typealias Vertex = SIMD2<Int>

    let map: [[Character]]

    func dimensions() -> (width: Int, height: Int) { (map[0].count, map.count) }

    func char(at vertex: Vertex) -> Character? {
      contains(vertex) ? map[vertex.y][vertex.x] : nil
    }

    func contains(_ vertex: Vertex) -> Bool {
      map.indices.contains(vertex.y) && map[0].indices.contains(vertex.x)
    }
  }
}
