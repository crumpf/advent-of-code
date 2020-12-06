//
//  main.swift
//  Day 6
//
//  Created by Christopher Rumpf on 12/3/20.
//

import Foundation

class Day6 {
  
}

extension Day6: Puzzle {
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
        let common = answers.reduce(answers.first!) { (result, set) in
          result.intersection(set)
        }
        return common.count
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
print(test1)

print("====Test 2====")
let test2 = day.part2(withInput: testInput)
print(test2)

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.raw)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.raw)
print(part2)
