import Algorithms

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { Int($0) }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let rules = safetyProtocols
    let ordering = safetyProtocols.pageOrderingRules.reduce(into: [Int:[Int]]()) { partialResult, rule in
      partialResult[rule.x] = (partialResult[rule.x] ?? []) + [rule.y]
    }
    let valid = rules.pageUpdates.filter { update in
      for i in (0..<(update.endIndex-1)) {
        let num = update[i]
        if false == update[i+1..<update.endIndex].allSatisfy({ later in
          return ordering[num]?.contains(later) ?? false
        }) {
          return false
        }
      }
      return true
    }
    return valid.map { $0[$0.count/2] }.reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    0
  }
  
  var safetyProtocols: SafetyProtocol {
    let sections = data.split(separator: "\n\n")
    let rules = sections[0].split(separator: "\n").map {
      let (_, x, y) = $0.matches(of: /(\d+)\|(\d+)/).first!.output
      return (Int(x)!, Int(y)!)
    }
    let updates = sections[1].split(separator: "\n").map {
      $0.split(separator: ",").map { Int($0)! }
    }
    return SafetyProtocol(pageOrderingRules: rules, pageUpdates: updates)
  }
  
  struct SafetyProtocol {
    let pageOrderingRules: [(x: Int, y: Int)]
    let pageUpdates: [[Int]]
  }
}
