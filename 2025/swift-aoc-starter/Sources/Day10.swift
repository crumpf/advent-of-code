import Algorithms
import Foundation

struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  //All that remains of the manual are some indicator light diagrams, button wiring schematics, and joltage requirements for each machine.
  struct Machine {
    let lightDiagram: [Bool]
    let buttonSchematics: [[Int]]
    let joltageRequirements: [Int]
  }

  /*
   data example:
   [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
   [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
   [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
   */
  var machines: [Machine] {
    let regex = /^\[(?<diagram>[.#]+)\](?<schematics>(?:\s*\(\d+(?:,\d+)*\))+)\s\{(?<joltages>[\d,]+)\}$/
    return data.split(separator: "\n").map { line in
      guard let match = line.firstMatch(of: regex) else { fatalError() }
      // named capture groups should be like
      // match.diagram = ".##."
      // match.schematics = " (3) (1,3) (2) (2,3) (0,2) (0,1)"
      // match.joltages = "3,5,4,7"
      return Machine(
        lightDiagram: match.diagram.map { $0 == "." ? false : true },
        buttonSchematics: match.schematics.split(separator: .whitespace).map {
          $0.dropFirst().dropLast().split(separator: ",").compactMap { Int($0) }
        },
        joltageRequirements: match.joltages.split(separator: ",").compactMap { Int($0) }
      )
    }
  }

  func part1() -> Any {
    machines.compactMap(fewestPressesToConfigureLights).reduce(0, +)
  }

  func part2() -> Any {
    machines.compactMap(fewestPressesToConfigureJoltages).reduce(0, +)
  }

  private func fewestPressesToConfigureLights(_ machine: Machine) -> Int? {
    let schematicsIndices = Array(machine.buttonSchematics.indices)
    // let's do a BFS search using the basic algorithm of my general-purpose BFS implementation
    // Each vertex will be the current state of the lights and the index of the button to press
    struct MachineVertex : Hashable {
      let lights: [Bool]
      let buttonIndex: Int
    }
    let toggle: (MachineVertex) -> [Bool] = { vertex in
      guard machine.buttonSchematics.indices.contains(vertex.buttonIndex) else {
        return vertex.lights
      }
      var lights = vertex.lights
      for i in machine.buttonSchematics[vertex.buttonIndex] {
        lights[i] = !lights[i]
      }
      return lights
    }
    // we'll start with all lights off and no button to press
    let start = MachineVertex(lights: Array(repeating: false, count: machine.lightDiagram.count), buttonIndex: -1)
    var frontier = Queue<PathNode<MachineVertex>>()
    frontier.enqueue(PathNode(vertex: start))
    var explored: Set<MachineVertex> = [start]
    while let currentNode = frontier.dequeue() {
      let toggledLights = toggle(currentNode.vertex)
      if toggledLights == machine.lightDiagram {
        // found the fewest presses
        var presses = 0
        currentNode.iteratePath(body: { i, node, stop in
          presses = i
        })
        return presses
      }
      let neighbors: [MachineVertex] = schematicsIndices.compactMap {
        // neighbors should exclude the index we just pressed since pressing it just goes back to a previous state
        guard $0 != currentNode.vertex.buttonIndex else { return nil }
        return MachineVertex(lights: toggledLights, buttonIndex: $0)
      }
      for successor in neighbors where !explored.contains(successor) {
        explored.insert(successor)
        frontier.enqueue(PathNode(vertex: successor, predecessor: currentNode))
      }
    }
    return nil
  }

  private func fewestPressesToConfigureJoltages(_ machine: Machine) -> Int? {
    let schematicsIndices = Array(machine.buttonSchematics.indices)
    // let's do a BFS search using the basic algorithm of my general-purpose BFS implementation
    // Each vertex will be the current state of the joltages and the index of the button to press
    struct MachineVertex : Hashable {
      let joltages: [Int]
      let buttonIndex: Int
    }
    let pressButton: (MachineVertex) -> [Int] = { vertex in
      guard machine.buttonSchematics.indices.contains(vertex.buttonIndex) else {
        return vertex.joltages
      }
      var joltages = vertex.joltages
      for i in machine.buttonSchematics[vertex.buttonIndex] {
        joltages[i] += 1
      }
      return joltages
    }
    // we'll start with all joltages 0 and no button to press
    let start = MachineVertex(joltages: Array(repeating: 0, count: machine.lightDiagram.count), buttonIndex: -1)
    var frontier = Queue<PathNode<MachineVertex>>()
    frontier.enqueue(PathNode(vertex: start))
    var explored: Set<MachineVertex> = [start]
    while let currentNode = frontier.dequeue() {
      let newJoltages = pressButton(currentNode.vertex)
      if newJoltages == machine.joltageRequirements {
        // found the fewest presses
        var presses = 0
        currentNode.iteratePath(body: { i, node, stop in
          presses = i
        })
        return presses
      }
      if zip(newJoltages, machine.joltageRequirements).allSatisfy({$0 <= $1}) {
        let neighbors: [MachineVertex] = schematicsIndices.compactMap {
          // neighbors don't exclude the index we just pressed since pressing multiple times is totally valid
          MachineVertex(joltages: newJoltages, buttonIndex: $0)
        }
        for successor in neighbors where !explored.contains(successor) {
          explored.insert(successor)
          frontier.enqueue(PathNode(vertex: successor, predecessor: currentNode))
        }
      }
    }
    return nil
  }

}
