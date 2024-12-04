import Algorithms
import RegexBuilder

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  // instructions like mul(X,Y), where X and Y are each 1-3 digit numbers
  var instructions: [[Instruction]] {
    let regex = /mul\((\d{1,3}),(\d{1,3})\)/
    return data.split(separator: "\n").map { line in
      line.matches(of: regex).map {
        let (_, x, y) = $0.output
        return Instruction(operation: "mul", x: Int(x)!, y: Int(y)!)
      }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    // add up all of the results for uncorrupted mul instructions
    instructions.reduce(0) {
      $0 + $1.reduce(0) { $0 + $1.x * $1.y }
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    0
  }
  
  struct Instruction {
    let operation: String
    let x: Int
    let y: Int
  }
}
