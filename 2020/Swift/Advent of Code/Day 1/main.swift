import Foundation

extension Array where Element == Int {
  func pairs(havingSum sum: Int) -> [(Int, Int)] {
    var pairs: [(Int, Int)] = []
    var elements = self
    while !elements.isEmpty {
      let a = elements.removeFirst()
      for b in elements {
        if a + b == sum {
          pairs.append((a, b))
        }
      }
    }
    return pairs
  }
  
  func trios(havingSum sum: Int) -> [(Int, Int, Int)] {
    var trios: [(Int, Int, Int)] = []
    guard count >= 3 else {
      return trios
    }
    
    for a in 0..<(self.count-2) {
      for b in (a+1)..<(self.count-1) {
        for c in (b+1)..<self.count where self[a] + self[b] + self[c] == sum {
          trios.append((self[a], self[b], self[c]))
        }
      }
    }
    return trios
  }
}

class Day1 {
  
  private func parseInput(_ input: [String]) -> [Int] {
    input.compactMap { Int($0) }
  }
  
}

extension Day1: Puzzle {
  func part1(withInput: [String]) -> String {
    let input = parseInput(withInput)
    let pairs = input.pairs(havingSum: 2020)
    
    return String(describing: pairs.map { $0.0 * $0.1 })
  }
  
  func part2(withInput: [String]) -> String {
    let input = parseInput(withInput)
    let trios = input.trios(havingSum: 2020)
    
    return String(describing: trios.map { $0.0 * $0.1 * $0.2 })
  }
}

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day1()

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.lines)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.lines)
print(part2)
