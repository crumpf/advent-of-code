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
    makeGarden().findRegions().map { $0.area * $0.perimeter }.reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    makeGarden().findRegions().map { $0.area * $0.sides }.reduce(0, +)
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

    // neighbor verticies contained within the map that are same value as the vertex passed in
    func neighbors(for vertex: Vertex) -> [Vertex] {
      [Vertex(1,0), Vertex(0,1), Vertex(-1,0), Vertex(0,-1)].map { vertex &+ $0 }.filter {
        guard let current = value(at: vertex), let next = value(at: $0), current == next else { return false }
        return true
      }
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
      var perimeter: Set<PerimeterPoint> = []
      var frontier = Queue<Vertex>()
      frontier.enqueue(start)
      var explored: Set<Vertex> = [start]
      while let currentNode = frontier.dequeue() {
        area += 1
        perimeter.formUnion(self.perimeter(for: currentNode))
        for successor in neighbors(for: currentNode) where !explored.contains(successor) {
          explored.insert(successor)
          frontier.enqueue(successor)
        }
      }
      visited.formUnion(explored)

      let sides = self.sides(ofPerimeter: perimeter)
      return Region(area: area, perimeter: perimeter.count, sides: sides)
    }
    
    func perimeter(for vertex: Vertex) -> [PerimeterPoint] {
      [(Vertex(-1,0), Edge.verticalLeft), (Vertex(1,0), Edge.verticalRight),
       (Vertex(0,-1), Edge.horizontalTop), (Vertex(0,1), Edge.horizontalBottom)]
        .map {
          (vertex &+ $0.0, $0.1)
        }
        .filter {
          !contains($0.0) || map[$0.0.y][$0.0.x] != map[vertex.y][vertex.x]
        }
        .map { PerimeterPoint(vertex: $0.0, edge: $0.1) }
    }

    func sides(ofPerimeter perimeter: Set<PerimeterPoint>) -> Int {
      var count = 0
      var remaining = Array(perimeter)
      while !remaining.isEmpty {
        let first = remaining.removeFirst()
        count += 1
        // find and remove other perimeter points that share this side
        switch first.edge {
        case .horizontalTop, .horizontalBottom:
          let horizontals = [Vertex(-1,0), Vertex(1,0)].compactMap {
            matching(first, in: remaining, alongVector: $0)
          }.flatMap { $0 }

          if !horizontals.isEmpty {
            horizontals.forEach { remaining.remove(at: remaining.firstIndex(of: $0)!) }
          }
        case .verticalLeft, .verticalRight:
          let verticals = [Vertex(0,-1), Vertex(0,1)].compactMap {
            matching(first, in: remaining, alongVector: $0)
          }.flatMap { $0 }

          if !verticals.isEmpty {
            verticals.forEach { remaining.remove(at: remaining.firstIndex(of: $0)!) }
          }
        }
      }
      return count
    }

    func matching(_ point: PerimeterPoint, in perimeter: [PerimeterPoint], alongVector: SIMD2<Int>) -> [PerimeterPoint]? {
      var mutablePerimeter = perimeter
      if let firstIndex = mutablePerimeter.firstIndex(of: PerimeterPoint(vertex: point.vertex &+ alongVector, edge: point.edge)) {
        let removed = mutablePerimeter.remove(at: firstIndex)
        return [removed] + (matching(removed, in: mutablePerimeter, alongVector: alongVector) ?? [])
      }
      return nil
    }

    struct Region {
      let area, perimeter, sides: Int
    }

    struct PerimeterPoint: Hashable {
      let vertex: Vertex
      let edge: Edge
    }

    enum Edge {
      case horizontalTop, horizontalBottom, verticalLeft, verticalRight
    }
  }

}
