//
//  Day2.swift
//  Day 2
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

struct Policy {
  let range: ClosedRange<Int>
  let letter: Character
}

struct PasswordRecord {
  let policy: Policy
  let password: String
}

class Day2: Day {
  /// How many passwords are valid according to their policies?
  func part1() -> String {
    let records = passwordRecords()
    let valid = records.reduce(0) { (result, record) -> Int in
      let count = record.password.filter { $0 == record.policy.letter }.count
      return result + (record.policy.range.contains(count) ? 1 : 0)
    }
    
    return String(describing: valid)
  }
  
  /// How many passwords are valid according to the new interpretation of the policies?
  func part2() -> String {
    let records = passwordRecords()
    let valid = records.reduce(0) { (result, record) -> Int in
      let min = record.policy.range.min()! - 1
      let max = record.policy.range.max()! - 1
      let first: UInt8 = record.password[min] == record.policy.letter ? 1 : 0
      let second: UInt8 = record.password[max] == record.policy.letter ? 1 : 0
      if first ^ second != 0 {
        return result + 1
      }
      return result
    }
    
    return String(describing: valid)
  }
  
  // Make password records from the puzzle input
  private func passwordRecords() -> [PasswordRecord] {
    input.lines().compactMap { (line) -> PasswordRecord? in
      let inComponents = line.components(separatedBy: ": ")
      guard inComponents.count == 2 else {
        return nil
      }
      let policyComponents = inComponents[0].components(separatedBy: " ")
      let rangeComponents = policyComponents[0].components(separatedBy: "-").compactMap { Int($0) }
      let range = rangeComponents[0]...rangeComponents[1]
      let policy = Policy(range: range, letter: Character(policyComponents[1]))
      return PasswordRecord(policy: policy, password: inComponents[1])
    }
  }
}
