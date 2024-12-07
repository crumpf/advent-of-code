import Algorithms

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func makeCalibrationEquations() -> [(Int, [Int])] {
    data.split(separator: "\n").map {
      let components = $0.split(separator: ": ")
      return (Int(components[0])!, components[1].split(separator: " ").map { Int($0)! })
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let equations = makeCalibrationEquations()
    return equations.filter(isPossible(equation:)).reduce(0) { $0 + $1.0 }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    0
  }

  func isPossible(equation: (Int, [Int])) -> Bool {
    let testValue = equation.0
    let numbers = equation.1
    let operatorCount = equation.1.count - 1
    for permutation in (0..<(1<<operatorCount)) {
      let binary = String(permutation, radix: 2)
      let padded = String(repeating: "0", count: operatorCount - binary.count) + binary
      let result = zip(padded, numbers.dropFirst()).reduce(numbers.first!) { partialResult, elem in
        elem.0 == "0" ? partialResult + elem.1 : partialResult * elem.1
      }
      if testValue == result {
        return true
      }
    }
    return false
  }
}
