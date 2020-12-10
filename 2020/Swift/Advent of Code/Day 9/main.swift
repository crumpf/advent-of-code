//
//  main.swift
//  Day Puzzle Template
//
//  Created by Christopher Rumpf on 12/9/20.
//

import Foundation

class Day9 {
  func hasPair(in list: Array<Int>, withSum sum: Int) -> Bool {
    let first = list.first { x in
      nil != list.first { y in
        guard x != y else { return false }
        return x + y == sum
      }
    }
    return first != nil
  }
}

extension Day9: Puzzle {
  // find the first number in the list (after the preamble) which is not the sum of two of the 25 numbers before it.
  func part1(withInput input: String) -> String {
    let numbers = input.lines().compactMap { Int($0) }
    let preambleCount = 25
    for i in (preambleCount..<numbers.count) {
      let preamble = Array(numbers[(i-preambleCount)..<i])
      if !hasPair(in: preamble, withSum: numbers[i]) {
        return String(numbers[i])
      }
    }
    
    return "Not found :("
  }
  
  func part2(withInput input: String) -> String {
    let numbers = input.lines().compactMap { Int($0) }
    let preambleCount = 25
    for i in (preambleCount..<numbers.count) {
      let preamble = Array(numbers[(i-preambleCount)..<i])
      if !hasPair(in: preamble, withSum: numbers[i]) {
        // i is the index of the invalid number
        let invalidNumber = numbers[i]
        for upper in stride(from: i-1, through: 0, by: -1) {
          var sum = 0
          for lower in stride(from: upper, through: 0, by: -1) {
            sum += numbers[lower]
            if invalidNumber == sum {
              // found our range
              let weakNumbers = Array(numbers[(lower...upper)])
              return String(weakNumbers.min()! + weakNumbers.max()!)
            }
          }
        }
      }
    }
    
    return "Not found :("
  }
}

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day9()

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.raw)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.raw)
print(part2)
