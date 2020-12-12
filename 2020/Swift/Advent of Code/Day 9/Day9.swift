//
//  Day9.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day9: Day {
  var preambleSize = 25
  
  /// The first step of attacking the weakness in the XMAS data is to find the first number in the list (after the preamble) which is not the sum of two of the 25 numbers before it. What is the first number that does not have this property?
  func part1() -> String {
    let numbers = input.lines().compactMap { Int($0) }
    for i in (preambleSize..<numbers.count) {
      let preamble = Array(numbers[(i-preambleSize)..<i])
      if !hasPair(in: preamble, withSum: numbers[i]) {
        return String(numbers[i])
      }
    }
    
    return "Not found :("
  }
  /// To find the encryption weakness, add together the smallest and largest number in this contiguous range; in this example, these are 15 and 47, producing 62.
  /// What is the encryption weakness in your XMAS-encrypted list of numbers?
  func part2() -> String {
    let numbers = input.lines().compactMap { Int($0) }
    for i in (preambleSize..<numbers.count) {
      let preamble = Array(numbers[(i-preambleSize)..<i])
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
  
  private func hasPair(in list: Array<Int>, withSum sum: Int) -> Bool {
    let first = list.first { x in
      nil != list.first { y in
        guard x != y else { return false }
        return x + y == sum
      }
    }
    return first != nil
  }
}
