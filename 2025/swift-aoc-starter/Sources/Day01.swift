import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var rotations: [Int] {
    let regex = /^([LR])(\d+)$/
    return data.split(separator: "\n").map { line in
      let match = try! regex.firstMatch(in: line)!
      let (direction, rotation) = (match.1, match.2)
      return direction == "L" ? -Int(rotation)! : Int(rotation)!
    }
  }

  func part1() -> Any {
    var dial = 50
    var password = 0
    rotations.forEach {
      dial = (dial + $0) % 100
      if dial == 0 {
        password += 1
      }
    }
    return password
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    0
  }
}
