import Algorithms
import RegexBuilder

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Range {
    let min, max: String
  }
  
  var ranges: [Range]{
    data.trimmingCharacters(in: .newlines).split(separator: ",").map {
      let r = $0.split(separator: "-")
      return Range(min: String(r[0]), max: String(r[1]))
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    sumOfInvalidIds(in: ranges)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    sumOfAllSillyIds(in: ranges)
  }
  
  func sumOfInvalidIds(in ranges: [Range]) -> Int {
    var invalidSum = 0
    
    ranges.forEach { r in
      let min = Int(r.min)!
      let max = Int(r.max)!
      
      (min...max).forEach { i in
        let str = "\(i)"
        let len = str.count
        if len.isMultiple(of: 2) {
          let first = str.dropLast(len / 2)
          let last = str.dropFirst(len / 2)
          if first == last {
            invalidSum += i
          }
        }
      }
    }
    
    return invalidSum
  }
  
  func sumOfAllSillyIds(in ranges: [Range]) -> Int {
    var invalidSum = 0
    
    ranges.forEach { r in
      let min = Int(r.min)!
      let max = Int(r.max)!
      
      (min...max).forEach { i in
        let str = "\(i)"
        if isRepeatedPattern(str) {
          invalidSum += i
        }
      }
    }
    
    return invalidSum
  }
  
  func isRepeatedPattern(_ s: String) -> Bool {
    guard s.count >= 2 else { return false }
    
    // look for 2 or more repetitions
    for reps in 2...s.count {
      if s.count.isMultiple(of: reps) {
        let subLen = s.count / reps
        if String(repeating: String(s.prefix(subLen)), count: reps) == s {
          return true
        }
      }
    }
    return false
  }

}
