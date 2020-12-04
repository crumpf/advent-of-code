import Foundation

struct Policy {
  let range: ClosedRange<Int>
  let letter: Character
}

struct PasswordRecord {
  let policy: Policy
  let password: String
}

extension StringProtocol {
  subscript(offset: Int) -> Character {
    self[index(startIndex, offsetBy: offset)]
  }
}

class Day2 {
  
  private func parseInput(_ input: [String]) -> [PasswordRecord] {
    input.compactMap { (line) -> PasswordRecord? in
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

extension Day2: Puzzle {
  func part1(withInput: [String]) -> String {
    let input = parseInput(withInput)
    let valid = input.reduce(0) { (result, record) -> Int in
      let count = record.password.filter { $0 == record.policy.letter }.count
      return result + (record.policy.range.contains(count) ? 1 : 0)
    }
    
    return String(describing: valid)
  }
  
  func part2(withInput: [String]) -> String {
    let input = parseInput(withInput)
    let valid = input.reduce(0) { (result, record) -> Int in
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
}

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day2()

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.lines)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.lines)
print(part2)
