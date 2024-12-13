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
    return machines.compactMap { $0.prizeSolution() }.reduce(0) { $0 + $1.tokens }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let machines = makeClawMachines()
    return machines.compactMap { $0.prizeSolution(correction: 10_000_000_000_000) }.reduce(0) { $0 + $1.tokens }
  }
  
  struct ClawMachine {
    typealias XY = (x: Int, y: Int)

    let a: XY
    let b: XY
    let prize: XY

    // This solution looks obtuse, but it's simply solving 2 linear equations by substitution one into the other.
    // I pen and papered the math and then coded it. The Double casts all over the place are 🤮.
    // The 2 equations I solved for are:
    //   (1) A * a.x + B * b.x = prize.x
    //   (2) A * a.y + B * b.y = prize.y
    // Only A and B, the number of presses, are unknown, so I just expressed a solution for B in one equation, and substitued
    // it into the other to solve for A. Then I substituted the solved A back into the B equation to solve for B. Since
    // the solution is on an integer boundary I rounded the A and B solutions and checked to make sure the equations
    // still held up before returning winning prize.
    // B = (prize.x - A * a.x) / b.x
    // A = (prize.y - (b.y * prize.x / b.x)) / (a.y - (b.y * a.x / b.x))
    // High school math FTW.
    func prizeSolution(correction: Int = 0) -> (tokens: Int, aPresses: Int, bPresses: Int)? {
      let fixed = (x: Double(prize.x) + Double(correction), y: Double(prize.y) + Double(correction))
      let doubleA = (x: Double(a.x), y: Double(a.y)), doubleB = (x: Double(b.x), y: Double(b.y))
      let A = ( (fixed.y - (doubleB.y * fixed.x / doubleB.x)) / (doubleA.y - (doubleB.y * doubleA.x / doubleB.x)) ).rounded()
      let B = ( (fixed.x - A * doubleA.x) / doubleB.x ).rounded()
      if A * doubleA.x + B * doubleB.x == fixed.x && A * doubleA.y + B * doubleB.y == fixed.y {
        return (Int(A)*3 + Int(B), Int(A), Int(B))
      } else {
        return nil
      }
    }
  }
}
