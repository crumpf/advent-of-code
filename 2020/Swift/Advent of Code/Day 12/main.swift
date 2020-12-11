//
//  main.swift
//  Day 12
//
//  Created by Christopher Rumpf on 12/12/20.
//

import Foundation

class Day12 {
  
}

extension Day12: Puzzle {
  func part1(withInput input: String) -> String {
    return "Not implemented"
  }
  
  func part2(withInput input: String) -> String {
    return "Not implemented"
  }
}

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day12()

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.raw)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.raw)
print(part2)
