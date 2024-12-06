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
    let safetyProtocol = makeSafetyProtocol()
    let valid = safetyProtocol.pageUpdates.filter { update in
      for (offset, page) in update.dropLast().enumerated() {
        if !Set(update.dropFirst(offset+1)).isSubset(of: safetyProtocol.pagesFollowingMap[page] ?? []) {
          return false
        }
      }
      return true
    }
    return valid.map { $0[$0.count/2] }.reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let safetyProtocol = makeSafetyProtocol()
    let isValidUpdate: ([Int]) -> Bool = { update in
      for (offset, page) in update.dropLast().enumerated() {
        if !Set(update.dropFirst(offset+1)).isSubset(of: safetyProtocol.pagesFollowingMap[page] ?? []) {
          return false
        }
      }
      return true
    }
    let correctedUpdate: ([Int]) -> [Int] = { update in
      var mutableUpdate = update
      while !isValidUpdate(mutableUpdate) {
        for (offset, page) in mutableUpdate.dropLast().enumerated() {
          let requiredFollowing = safetyProtocol.pagesFollowingMap[page] ?? []
          let following = mutableUpdate.dropFirst(offset+1)
          let neededEarlier = following.filter { !requiredFollowing.contains($0) }
          if !neededEarlier.isEmpty {
            let neededLater = following.filter { requiredFollowing.contains($0) }
            mutableUpdate = neededEarlier + mutableUpdate[0...offset] + neededLater
            break
          }
        }
      }
      return mutableUpdate
    }

    return safetyProtocol.pageUpdates
      .filter { !isValidUpdate($0) }
      .map { correctedUpdate($0) }
      .map { $0[$0.count/2] }.reduce(0, +)
  }
  
  func makeSafetyProtocol() -> SafetyProtocol {
    let sections = data.split(separator: "\n\n")
    let rules = sections[0].split(separator: "\n").map {
      let (_, x, y) = $0.matches(of: /(\d+)\|(\d+)/).first!.output
      return (x: Int(x)!, y: Int(y)!)
    }
    let updates = sections[1].split(separator: "\n").map {
      $0.split(separator: ",").map { Int($0)! }
    }
    let followingMap = rules.reduce(into: [Int: Set<Int>]()) { partialResult, rule in
      if partialResult[rule.x] != nil {
        partialResult[rule.x]!.insert(rule.y)
      } else {
        partialResult[rule.x] = Set<Int>([rule.y])
      }
    }
    return SafetyProtocol(pageOrderingRules: rules, pageUpdates: updates, pagesFollowingMap: followingMap)
  }
  
  struct SafetyProtocol {
    let pageOrderingRules: [(x: Int, y: Int)]
    let pageUpdates: [[Int]]
    let pagesFollowingMap: [Int: Set<Int>]
  }
}
