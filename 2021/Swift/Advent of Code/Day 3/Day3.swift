//
//  Day3.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/03/21.
//
//  https://adventofcode.com/2021/day/3

import Foundation

class Day3: Day {
  /// Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together. What is the power consumption of the submarine? (represented in decimal, not binary)
  func part1() -> String {
    let mostCommon = diagnostics.reduce(into: Array.init(repeating: 0, count: diagnosticBitSize)) { res, diag in
      let binary = diag.map { Int(String($0))! }
      for (n, b) in binary.enumerated() {
        res[n] += b
      }
    }
      .map { $0 > (diagnostics.count/2) ? "1" : "0" }
      .joined(separator: "")
    
    let gamma = Int(mostCommon, radix: 2)!
    let epsilon = Int(mostCommon.map { $0 == "0" ? "1" : "0"}.joined(separator: ""), radix: 2)!
    print("g: \(String(describing: gamma)), e: \(String(describing: epsilon))")
    
    return "\(gamma * epsilon)"
  }
  
  /// Use the binary numbers in your diagnostic report to calculate the oxygen generator rating and CO2 scrubber rating, then multiply them together. What is the life support rating of the submarine? (Be sure to represent your answer in decimal, not binary.)
  func part2() -> String {
    // need to find: o2GenRating * co2ScrubberRating
    //
    // consider first bit in each diag report
    //   - keep only #s selected by **bit criteria** for the rating you're searching
    //   - if one is left, stop. this is the one
    //   - else repeat, considering next bit to the right
    //
    // bit criteria
    //   - o2, most common value in bit position, keep only #s with that bit. if equally common, keep values with a 1 as considered
    //   - co2, least common in bit position, keep only #s with that bit. if equally common, keep values with a 0 as considered
    
    var o2Report = diagnostics
    for (n, _) in diagnostics[0].enumerated() {
      if o2Report.count <= 1 {
        break
      }
      let onesCount = onesCountInList(o2Report, atPosition: n)
      let bitCriteria: Character = onesCount >= o2Report.count - onesCount ? "1" : "0"
      o2Report.removeAll { diag in
        diag[n] != bitCriteria
      }
    }
    print("final o2Report: \(o2Report)")
    
    var co2Report = diagnostics
    for (n, _) in diagnostics[0].enumerated() {
      if co2Report.count <= 1 {
        break
      }
      let onesCount = onesCountInList(co2Report, atPosition: n)
      let bitCriteria: Character = co2Report.count - onesCount <= onesCount ? "0" : "1"
      co2Report.removeAll { diag in
        diag[n] != bitCriteria
      }
    }
    print("final co2Report: \(co2Report)")

    guard o2Report.count == 1,
          let o2GenRating = Int(o2Report[0], radix: 2),
          co2Report.count == 1,
          let co2ScrubberRating = Int(co2Report[0], radix: 2)
    else {
      print("Error finding ratings.")
      return "Error"
    }

    print("O2: \(String(describing: o2GenRating)), CO2: \(String(describing: co2ScrubberRating))")
    
    return "\(o2GenRating * co2ScrubberRating)"
  }
  
  private(set) lazy var diagnostics = input.lines()
  
  var diagnosticBitSize: Int { diagnostics[0].count }
  
  private func onesCountInList(_ list: [String], atPosition pos: Int) -> Int {
    list.reduce(0) { res, s in
      s[pos] == "1" ? res + 1 : res
    }
  }
  
}
