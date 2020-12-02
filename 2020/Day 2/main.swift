// https://adventofcode.com/2020/day/2

import Foundation

//--- Day 2: Password Philosophy ---

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let rawInput = try String(contentsOf: fileURL, encoding: .utf8)

struct Policy {
  let range: ClosedRange<Int>
  let letter: Character
}

struct PasswordRecord {
  let policy: Policy
  let password: String
}

let input = rawInput.components(separatedBy: "\n").compactMap { (line) -> PasswordRecord? in
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

//  --- Part One ---

print("====Part 1====")

let valid = input.reduce(0) { (result, record) -> Int in
  let count = record.password.filter { $0 == record.policy.letter }.count
  return result + (record.policy.range.contains(count) ? 1 : 0)
}

print(valid)

//  --- Part Two ---

print("====Part 2====")

extension StringProtocol {
  subscript(offset: Int) -> Character {
    self[index(startIndex, offsetBy: offset)]
  }
}

let valid2 = input.reduce(0) { (result, record) -> Int in
  let min = record.policy.range.min()! - 1
  let max = record.policy.range.max()! - 1
  let first: UInt8 = record.password[min] == record.policy.letter ? 1 : 0
  let second: UInt8 = record.password[max] == record.policy.letter ? 1 : 0
  if first ^ second != 0 {
    return result + 1
  }
  return result
}

print(valid2)
