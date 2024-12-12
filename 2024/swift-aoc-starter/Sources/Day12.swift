import Algorithms

struct Day12: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func makeGarden() -> Garden {
    let map = data.split(separator: "\n").map { Array($0) }
    return Garden(map: map)
  }
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    makeGarden().priceToFenceAllRegions()
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    0
  }
  
  struct Garden {
    typealias Vertex = SIMD2<Int>

    let map: [[Character]]

    func dimensions() -> (width: Int, height: Int) { (map[0].count, map.count) }

    func value(at vertex: Vertex) -> Character? {
      contains(vertex) ? map[vertex.y][vertex.x] : nil
    }

    func contains(_ vertex: Vertex) -> Bool {
      map.indices.contains(vertex.y) && map[0].indices.contains(vertex.x)
    }
    
    func adjacentVerticies(to vertex: Vertex) -> [Vertex] {
      guard contains(vertex) else { return [] }
      return [Vertex(0,-1), Vertex(0,1), Vertex(-1,0), Vertex(1,0)].map { vertex &+ $0 }
    }
    
    func neighbors(for vertex: Vertex) -> [Vertex] {
      adjacentVerticies(to: vertex).filter {
        guard let current = value(at: vertex), let next = value(at: $0), current == next else { return false }
        return true
      }
    }
    
    func priceToFenceAllRegions() -> Int {
      findRegions().map { $0.area * $0.perimeter }.reduce(0, +)
    }
    
    func findRegions() -> [Region] {
      var regions: [Region] = []
      var visited = Set<Vertex>()
      for (y, row) in map.enumerated() {
        for x in row.indices {
          let start = Vertex(x, y)
          if !visited.contains(start) {
            regions.append(region(from: start, visited: &visited))
          }
        }
      }
      return regions
    }
    
    func region(from start: Vertex, visited: inout Set<Vertex>) -> Region {
      var area = 0
      var perimeters: [Vertex] = []
      var frontier = Queue<Vertex>()
      frontier.enqueue(start)
      var explored: Set<Vertex> = [start]
      while let currentNode = frontier.dequeue() {
        area += 1
        perimeters.append(contentsOf: perimeter(for: currentNode))
        for successor in neighbors(for: currentNode) where !explored.contains(successor) {
          explored.insert(successor)
          frontier.enqueue(successor)
        }
      }
      visited.formUnion(explored)
      return Region(area: area, perimeter: perimeters.count)
    }
    
    func perimeter(for vertex: Vertex) -> [Vertex] {
      adjacentVerticies(to: vertex).filter {
        !contains($0) || map[$0.y][$0.x] != map[vertex.y][vertex.x]
      }
    }
    
    struct Region {
      let area, perimeter: Int
    }
  }

}
