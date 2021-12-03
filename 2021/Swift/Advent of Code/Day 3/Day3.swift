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
    let result = diagnostics.reduce(into: Array.init(repeating: 0, count: diagnosticBitSize)) { res, diag in
      let binary = diag.map { Int(String($0))! }
      for (n, b) in binary.enumerated() {
        res[n] += b
      }
    }
      .map { $0 > (diagnostics.count/2) ? "1" : "0" }
      .joined(separator: "")
    
    let gamma = Int(result, radix: 2)!
    let epsilon = Int(result.map { $0 == "0" ? "1" : "0"}.joined(separator: ""), radix: 2)!
    print("g: \(String(describing: gamma)), e: \(String(describing: epsilon))")
    
    return "\(gamma * epsilon)"
  }
  
  ///
  func part2() -> String {
    "Not Implemented"
  }
  
  private(set) lazy var diagnostics = input.lines()
  
  var diagnosticBitSize: Int { diagnostics[0].count }
  
}
