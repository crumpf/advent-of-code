import Algorithms
import Foundation

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var calibrationEquations: [(Int, [Int])] {
    data.split(separator: "\n").map {
      let components = $0.split(separator: ": ")
      return (Int(components[0])!, components[1].split(separator: " ").map { Int($0)! })
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
//    calibrationEquations.filter(isPossible(equation:)).reduce(0) { $0 + $1.0 }
    calibrationEquations.filter { isPossible(testValue: $0.0, numbers: $0.1) }.reduce(0) { $0 + $1.0 }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
//    calibrationEquations.filter(isPossibleWithConcatenation(equation:)).reduce(0) { $0 + $1.0 }
    calibrationEquations.filter { isPossible(testValue: $0.0, numbers: $0.1, supportsConcatenation: true) }.reduce(0) { $0 + $1.0 }
  }

  func isPossible(equation: (Int, [Int])) -> Bool {
    let testValue = equation.0, numbers = equation.1
    let operatorCount = numbers.count - 1
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

  func isPossibleWithConcatenation(equation: (Int, [Int])) -> Bool {
    let testValue = equation.0, numbers = equation.1
    let operatorCount = numbers.count - 1
    let numberOfPermutations = Int("\(pow(3, operatorCount))")!
    for permutation in (0..<numberOfPermutations) {
      let radix3 = String(permutation, radix: 3)
      let padded = String(repeating: "0", count: operatorCount - radix3.count) + radix3
      let result = zip(padded, numbers.dropFirst()).reduce(numbers.first!) { partialResult, elem in
        switch elem.0 {
        case "0":
          return partialResult + elem.1
        case "1":
          return partialResult * elem.1
        default: // case "2"
          return Int("\(partialResult)\(elem.1)")!
        }
      }
      if testValue == result {
        return true
      }
    }
    return false
  }

  // speedier recursive solution to the iterative solutions above
  func isPossible(testValue: Int, numbers: [Int], supportsConcatenation: Bool = false) -> Bool {
    guard numbers.count > 1, numbers.first! <= testValue else {
      return numbers.first == testValue
    }
    
    if isPossible(testValue: testValue, numbers: [numbers[0] + numbers[1]] + numbers.dropFirst(2), supportsConcatenation: supportsConcatenation)
        || isPossible(testValue: testValue, numbers: [numbers[0] * numbers[1]] + numbers.dropFirst(2), supportsConcatenation: supportsConcatenation)
        || (supportsConcatenation && isPossible(testValue: testValue, numbers: [Int("\(numbers[0])\(numbers[1])")!] + numbers.dropFirst(2), supportsConcatenation: supportsConcatenation)) {
      return true
    }

    return false
  }
}
