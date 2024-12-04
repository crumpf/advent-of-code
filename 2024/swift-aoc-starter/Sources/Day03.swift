import Algorithms
import RegexBuilder

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var mulInstructions: [[(x: Int, y: Int)]] {
    let regex = /mul\((\d{1,3}),(\d{1,3})\)/
    return data.split(separator: "\n").map { line in
      line.matches(of: regex).map {
        let (_, x, y) = $0.output
        return (Int(x)!, Int(y)!)
      }
    }
  }
  
  var instructions: [[(instruction: String, x: Int, y: Int)]] {
    let regex = /mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/
    let mulCapture = /mul\((\d{1,3}),(\d{1,3})\)/
    return data.split(separator: "\n").map { line in
      line.matches(of: regex).map {
        if $0.output.starts(with: "mul") {
          let (_, x, y) = $0.output.matches(of: mulCapture).first!.output
          return (String($0.output), Int(x)!, Int(y)!)
        }
        return (String($0.output), 0, 0)
      }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    // add up all of the results for uncorrupted mul instructions
    mulInstructions.reduce(0) {
      $0 + $1.reduce(0) { $0 + $1.x * $1.y }
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    var enabled = true
    return instructions.flatMap { $0 }.reduce(0) {
      if $1.instruction.starts(with: "mul") {
        return $0 + (enabled ? $1.x * $1.y : 0)
      }
      if $1.instruction == "do()" {
        enabled = true
      }
      if $1.instruction == "don't()" {
        enabled = false
      }
      return $0
    }
  }
}
