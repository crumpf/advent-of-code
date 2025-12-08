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

  func part2() -> Any {
    var dial = 50
    var password = 0
    rotations.forEach {
      let revs = abs($0) / 100
      let mod = $0 % 100
      
      password += revs // guaranteed to pass 0 on every complete revolution
      
      // look for any giblets
      if $0 > 0 {
        // clockwise
        if dial + mod >= 100 {
          password += 1
        }
      } else if $0 < 0 {
        // anti-clockwise
        if dial != 0 && (dial + mod) <= 0 {
          password += 1
        }
      }
      
      let nextDial = (dial + $0) % 100
      let normalizedNextDial = nextDial >= 0 ? nextDial : 100 + nextDial
      dial = normalizedNextDial
    }
    return password
  }
}
