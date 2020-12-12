//
//  Day6.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day6: Day {
  /// For each group, count the number of questions to which _anyone_ answered "yes". What is the sum of those counts?
  func part1() -> String {
    // This approach just concatenates the answers in a group by tossing out the newline and then makes a set.
    // Could also have used the approach I did in part 2 but used a union instead of an intersection.
    String(
      input.trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n\n")
        .map { Set($0).subtracting("\n") }
        .reduce(0) { (result, answers) -> Int in
          result + answers.count
        }
    )
  }
  
  /// For each group, count the number of questions to which _everyone_ answered "yes". What is the sum of those counts?
  func part2() -> String {
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
