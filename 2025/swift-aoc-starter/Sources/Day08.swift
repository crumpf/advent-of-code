import Algorithms
import Foundation

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var boxCoords: [Coord3D] {
    data.split(separator: "\n").map {
      let coords = $0.split(separator: ",")
      return Coord3D(x: Int(coords[0])!, y: Int(coords[1])!, z: Int(coords[2])!)
    }
  }

  func part1() -> Any {
    connect(count: 1000)
  }

  func testPart1() -> Any {
    connect(count: 10)
  }

  func connect(count: Int) -> Any {
    let boxes = boxCoords
    var circuits = boxes.map { Set([$0]) }
    let connections = calculateAndSortConnections(boxes: boxes)

    for i in 0..<count {
      let closest = connections[i]

      let pair = Array(closest.pair)
      let fromIndex = circuits.firstIndex {
        $0.contains(pair[0])
      }!
      let toIndex = circuits.firstIndex {
        $0.contains(pair[1])
      }!

      if fromIndex != toIndex {
        circuits[fromIndex].formUnion(circuits[toIndex])
        circuits.remove(at: toIndex)
      }
    }

    return circuits.map(\.count).sorted(by: >)[0..<3].reduce(1, *)
  }

  func part2() -> Any {
    makeSingleCircuit()
  }
  
  func makeSingleCircuit() -> Any {
    let boxes = boxCoords
    var circuits = boxes.map { Set([$0]) }
    let connections = calculateAndSortConnections(boxes: boxes)
    
    for connection in connections {
      let pair = Array(connection.pair)
      let fromIndex = circuits.firstIndex {
        $0.contains(pair[0])
      }!
      let toIndex = circuits.firstIndex {
        $0.contains(pair[1])
      }!

      if fromIndex != toIndex {
        circuits[fromIndex].formUnion(circuits[toIndex])
        circuits.remove(at: toIndex)
      }

      if circuits.count == 1 {
        return pair[0].x * pair[1].x
      }
    }
    
    return "oops..."
  }

  struct Coord3D: Hashable {
    let x, y, z: Int

    func euclideanDistance(to: Coord3D) -> Double {
      (pow(Double(to.x-self.x), 2) + pow(Double(to.y-self.y), 2) + pow(Double(to.z-self.z), 2)).squareRoot()
    }
  }

  struct Connection: Hashable {
    let pair: Set<Coord3D>
    let distance: Double

    init(from: Coord3D, to: Coord3D) {
      pair = [from, to]
      distance = from.euclideanDistance(to: to)
    }
  }

  func calculateAndSortConnections(boxes: [Coord3D]) -> [Connection] {
    var connections: [Connection] = []

    for i in 0..<boxes.count {
      for j in i+1..<boxes.count {
        let connection = Connection(from: boxes[i], to: boxes[j])
        connections.append(connection)
      }
    }

    return connections.sorted { a, b in
      a.distance < b.distance
    }
  }

}
