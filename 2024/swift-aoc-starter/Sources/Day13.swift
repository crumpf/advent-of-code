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
    // The 2 equations I solved for are:
    //   (1) A * a.x + B * b.x = prize.x
    //   (2) A * a.y + B * b.y = prize.y
    // Only A and B, the number of presses, are unknown, so I expressed a solution for B in one equation, and substitued
    // it into the other to solve for A. Then I substituted the solved A back into the B equation to solve for B. Since
    // the solution is on an integer boundary, A and B solutions are checked to make sure they don't have remainders
    // before returning winning prize. Ultimately,
    // B = (prize.x - A * a.x) / b.x
    // A = (b.x * prize.y - b.y * prize.x) / (b.x * a.y - b.y * a.x)
    // High school math FTW.
    func prizeSolution(correction: Int = 0) -> (tokens: Int, aPresses: Int, bPresses: Int)? {
      let fixed = (x: Double(prize.x) + Double(correction), y: Double(prize.y) + Double(correction))
      let ax = Double(a.x), ay = Double(a.y), bx = Double(b.x), by = Double(b.y)
      let A = ( (bx * fixed.y - by * fixed.x) / (bx * ay - by * ax) )
      let B = ( (fixed.x - A * ax) / bx )

      if A.truncatingRemainder(dividingBy: 1) == 0 && B.truncatingRemainder(dividingBy: 1) == 0 {
        return (Int(A)*3 + Int(B), Int(A), Int(B))
      } else {
        return nil
      }
    }
  }
}
