//
//  Day14.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day14: Day {
  /// Execute the initialization program. What is the sum of all values left in memory after it completes?
  func part1() -> String {
    var memory = Array<UInt64>(repeating: 0, count: Int(UInt16.max))
    var mask = ""
    var bitmasks = (writeZeros: UInt64.max, writeOnes: UInt64.min)
    
    for line in input.lines() {
      let components = line.components(separatedBy: .whitespaces)
      if components[0] == "mask" {
        mask = components.last!
        bitmasks = self.bitmasks(from: mask)
      } else if let first = components.first,
                let last = components.last,
                let address = Int(first.replacingOccurrences(of: #"\D"#, with: "", options: .regularExpression)),
                let value = UInt64(last) {
        memory[address] = (value & bitmasks.writeZeros) | bitmasks.writeOnes
      }
    }
    
    return String(memory.reduce(0, +))
  }
  
  /// Execute the initialization program using an emulator for a version 2 decoder chip. What is the sum of all values left in memory after it completes?
  func part2() -> String {
    var memory = [UInt64: UInt64]()
    var mask = ""
    var orMask = UInt64.min
    var xMask = UInt64.min
    
    for line in input.lines() {
      let components = line.components(separatedBy: .whitespaces)
      if components[0] == "mask" {
        mask = components.last!
        orMask = UInt64(mask.replacingOccurrences(of: "X", with: "0", options: .regularExpression), radix: 2)!
        xMask = UInt64(
          mask
            .replacingOccurrences(of: #"\d"#, with: "0", options: .regularExpression)
            .replacingOccurrences(of: "X", with: "1", options: .regularExpression),
          radix: 2
        )!
      } else if let first = components.first,
                let last = components.last,
                let address = UInt64(first.replacingOccurrences(of: #"\D"#, with: "", options: .regularExpression)),
                let value = UInt64(last) {
        addressesApplying(xMask: xMask, orMask: orMask, toAddress: address).forEach {
          memory[$0] = value
        }
      }
    }
    
    return String(memory.values.reduce(0, +))
  }
  
  private func bitmasks(from mask: String) -> (writeZeros: UInt64, writeOnes: UInt64) {
    let writeZerosMask = UInt64(mask.replacingOccurrences(of: "X", with: "1", options: .regularExpression), radix: 2)!
    let writeOnesMask = UInt64(mask.replacingOccurrences(of: "X", with: "0", options: .regularExpression), radix: 2)!
    return (writeZeros: writeZerosMask, writeOnes: writeOnesMask)
  }
  
  private func addressesApplying(xMask: UInt64, orMask: UInt64, toAddress address: UInt64) -> [UInt64] {
    let result = (address | orMask) & ~xMask
    var adds = [result]
    
    var pow2: UInt64 = 1
    while pow2 <= xMask {
      if pow2 & xMask != 0 {
        adds.forEach { adds.append($0 | pow2) }
      }
      pow2 = pow2 << 1
    }
    
    return adds
  }
}

