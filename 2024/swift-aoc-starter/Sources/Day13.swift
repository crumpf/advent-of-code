import Algorithms

struct Day13: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func makeClawMachines() -> [ClawMachine] {
    data.split(separator: "\n\n").map {
      let (_, ax, ay) = $0.matches(of: /Button A: X\+(\d+), Y\+(\d+)/)[0].output
      let (_, bx, by) = $0.matches(of: /Button B: X\+(\d+), Y\+(\d+)/)[0].output
      let (_, px, py) = $0.matches(of: /Prize: X=(\d+), Y=(\d+)/)[0].output
      return ClawMachine(a: (Int(ax)!,Int(ay)!), b: (Int(bx)!,Int(by)!), prize: (Int(px)!,Int(py)!))
    }
  }
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let machines = makeClawMachines()
    return machines.compactMap { $0.minimumCost }.reduce(0) { $0 + $1.tokens }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    0
  }
  
  struct ClawMachine {
    let a: (x: Int, y: Int)
    let b: (x: Int, y: Int)
    let prize: (x: Int, y: Int)

    var minimumCost: (tokens: Int, aPresses: Int, bPresses: Int)? {
      var minCost: (tokens: Int, aPresses: Int, bPresses: Int)? = nil
      for pressA in (1...100) {
        for pressB in (1...100) {
          let x = pressA * a.x + pressB * b.x
          let y = pressA * a.y + pressB * b.y
          if x == prize.x && y == prize.y {
            let cost = pressA * 3 + pressB
            if minCost == nil || cost < minCost!.tokens {
              minCost = (cost, pressA, pressB)
            }
          }
        }
      }
      return minCost
    }
  }
}
