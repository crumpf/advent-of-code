//
//  main.swift
//  Day 6
//
//  Created by Christopher Rumpf on 12/6/20.
//

import Foundation

class Day6 {
  
}

extension Day6: Puzzle {
  // This approach just concatenates the answers in a group by tossing out the newline and then makes a set.
  // Could also have used the approach I did in part 2 but used a union instead of an intersection.
  func part1(withInput input: String) -> String {
    String(
      input.trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n\n")
        .map { Set($0).subtracting("\n") }
        .reduce(0) { (result, answers) -> Int in
          result + answers.count
        }
    )
  }
  
  func part2(withInput input: String) -> String {
    let answer = input.trimmingCharacters(in: .whitespacesAndNewlines)
      .components(separatedBy: "\n\n")
      .map { $0.split(separator: "\n").map { Set($0) } }
      .map { answers -> Int in
        guard let first = answers.first else { return 0 }
        return answers.reduce(first) { $0.intersection($1) }.count
      }
      .reduce(0) { $0 + $1 }
    
    return String(answer)
  }
}

let testInput = """
abc

a
b
c

ab
ac

a
a
a
a

b
"""

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day6()

print("====Test 1====")
let test1 = day.part1(withInput: testInput)
print(Int(test1) == 11)

print("====Test 2====")
let test2 = day.part2(withInput: testInput)
print(Int(test2) == 6)

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.raw)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.raw)
print(part2)
