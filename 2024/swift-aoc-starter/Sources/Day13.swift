import Algorithms

struct Day13: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func makeClawMachines() -> [ClawMachine] {
    data.split(separator: "\n\n").map {
      let behavior = $0.split(separator: "\n")
      let buttonARegex = /Button A: X\+(\d+), Y\+(\d+)/
      let buttonBRegex = /Button B: X\+(\d+), Y\+(\d+)/
      let prizeRegex = /Prize: X=(\d+), Y=(\d+)/
      let (_, ax, ay) = $0.matches(of: buttonARegex)[0].output
      let (_, bx, by) = $0.matches(of: buttonBRegex)[0].output
      let (_, px, py) = $0.matches(of: prizeRegex)[0].output
      return ClawMachine(a: (Int(ax)!,Int(ay)!), b: (Int(bx)!,Int(by)!), prize: (Int(px)!,Int(py)!))
    }
  }
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let cm = makeClawMachines()
    return cm.count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    0
  }
  
  struct ClawMachine {
    let a: (x: Int, y: Int)
    let b: (x: Int, y: Int)
    let prize: (x: Int, y: Int)
  }
}
