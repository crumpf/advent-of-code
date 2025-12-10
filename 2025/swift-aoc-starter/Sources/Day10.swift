import Algorithms
import Foundation

struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  //All that remains of the manual are some indicator light diagrams, button wiring schematics, and joltage requirements for each machine.
  struct Machine {
    let lightDiagram: [Bool]
    let schematics: [[Int]]
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
        schematics: match.schematics.split(separator: .whitespace).map {
          $0.dropFirst().dropLast().split(separator: ",").compactMap { Int($0) }
        },
        joltageRequirements: match.joltages.split(separator: ",").compactMap { Int($0) }
      )
    }
  }

  func part1() -> Any {
    7
  }

  func part2() -> Any {
    0
  }
}
