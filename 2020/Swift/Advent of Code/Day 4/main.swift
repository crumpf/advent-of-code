//
//  main.swift
//  Day 4
//
//  Created by Christopher Rumpf on 12/3/20.
//

import Foundation

class Day4 {
  
}

extension Day4: Puzzle {
  func part1(withInput: [String]) -> String {
    return "Not implemented"
  }
  
  func part2(withInput: [String]) -> String {
    return "Not implemented"
  }
}

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day4()

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.lines)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.lines)
print(part2)
