// https://adventofcode.com/2020/day/1

// --- Day 1: Report Repair ---

//The tropical island has its own currency and is entirely cash-only. The gold coins used there have a little picture of a starfish; the locals just call them stars. None of the currency exchanges seem to have heard of them, but somehow, you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.
//
//To save your vacation, you need to get all fifty stars by December 25th.
//
//Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!
//
//Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input); apparently, something isn't quite adding up.
//
//Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.

import Foundation

extension Array where Element == Int {

  func pairs(havingSum sum: Int) -> [(Int, Int)] {
    var pairs: [(Int, Int)] = []
    var elements = self
    while !elements.isEmpty {
      let a = elements.removeFirst()
      for b in elements {
        if a + b == sum {
          pairs.append((a, b))
        }
      }
    }
    return pairs
  }
  
}

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let rawInput = try String(contentsOf: fileURL, encoding: .utf8)

//let input = [1721, 979, 366, 299, 675, 1456]
let input = rawInput.components(separatedBy: "\n").compactMap { Int($0) }
let sum = 2020

print("====Part 1====")
print("Pairs in the input data that sum to \(sum):")
let pairs = input.pairs(havingSum: sum)
print(pairs)
print("Products of the pairs:")
print(pairs.map { $0.0 * $0.1 })

//  --- Part Two ---
//
//  The Elves in accounting are thankful for your help; one of them even offers you a starfish coin they had left over from a past vacation. They offer you a second one if you can find three numbers in your expense report that meet the same criteria.
//
//  Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. Multiplying them together produces the answer, 241861950.
//
//  In your expense report, what is the product of the three entries that sum to 2020?


extension Array where Element == Int {
  
  func trios(havingSum sum: Int) -> [(Int, Int, Int)] {
    var trios: [(Int, Int, Int)] = []
    for a in 0...(self.count-3) {
      for b in (a+1)...(self.count-2) {
        for c in (b+1)...(self.count-1) {
          if self[a] + self[b] + self[c] == sum {
            trios.append((self[a], self[b], self[c]))
          }
        }
      }
    }
    return trios
  }
  
}

print("====Part 2====")
print("Trios in the input data that sum to \(sum):")
let trios = input.trios(havingSum: 2020)
print(trios)
print("Products of the trios:")
print(trios.map { $0.0 * $0.1 * $0.2 })
