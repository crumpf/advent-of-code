import Algorithms

struct Day11: AdventDay {
  var data: String

  var devicesToOutputs: [String: [String]] {
    data.split(separator: "\n").reduce(into: [String: [String]](), { partialResult, line in
      let parts = line.split(separator: ":")
      partialResult[String(parts[0])] = parts[1].split(separator: " ").map(String.init)
    })
  }

  func part1() -> Any {
    let pathsToOut = traverseDevicesMap(devicesToOutputs, fromPath: ["you"], to: "out")
    return pathsToOut.count
  }

  func part2() -> Any {
    0
  }

  private func traverseDevicesMap(_ map: [String: [String]], fromPath path: [String], to goal: String) -> [[String]] {
    var result = [[String]]()
    for device in map[path.last!]! {
      if device == goal {
        result.append(path + [device])
      } else {
        result += traverseDevicesMap(map, fromPath: path + [device], to: goal)
      }
    }
    return result
  }

}
