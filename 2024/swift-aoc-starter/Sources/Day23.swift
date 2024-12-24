import Algorithms

struct Day23: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func part1() -> Any {
    let network = data.split(separator: "\n").reduce(into: [String:[String]]()) {
      let splits = $1.components(separatedBy: "-")
      $0[splits[0]] != nil ? $0[splits[0]]?.append(splits[1]) : ($0[splits[0]] = [splits[1]])
      $0[splits[1]] != nil ? $0[splits[1]]?.append(splits[0]) : ($0[splits[1]] = [splits[0]])
    }
    
    var triads: Set<Set<String>> = []
    for node in network {
      node.value.forEach { connection in
        network[connection]!.forEach {
          if Set(network[$0]!).contains(node.key) {
            triads.insert(Set([node.key, connection, $0]))
          }
        }
      }
    }
    
    return triads.filter {
      $0.contains { $0.starts(with: "t") }
    }
    .count
  }

  func part2() -> Any {
    0
  }
}
