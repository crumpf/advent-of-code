//
//  Day24.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day24: Day {
  func part1() -> String {
    let result = largestValidFourteenDigitModelNumberWithoutZeroes()
    return "\(result)"
  }
  
  func part2() -> String {
    return ""
  }
  
  var monadProgram: [String] {
    input.lines()
  }
  
  func largestValidFourteenDigitModelNumberWithoutZeroes() -> Int {
    // hm... iterating all 14 digit numbers, even tossing out ones including 0's is _way_ too many to brute force, 9^14.
    // but how to figure out what range or sets to look at? ☹️🤔
    
    let num = 99_999_999_999_999
    var alu = ALU(program: monadProgram, input: ALUInput(value: String(num)))
    alu.run()
    // after MONAD has finished running all of its instructions, it will indicate that the model number was valid by leaving a 0 in variable z. However, if the model number was invalid, it will leave some other non-zero value in z.
    
    return 0
  }
  
  struct ALUInput {
    let value: String
    var offset = 0
    
    mutating func read() -> Character? {
      guard offset < value.count else { return nil }
      let c = value[offset]
      offset += 1
      return c
    }
  }
  
  /*
   The ALU is a four-dimensional processing unit: it has integer variables w, x, y, and z. These variables all start with the value 0. The ALU also supports six instructions:

   inp a - Read an input value and write it to variable a.
   add a b - Add the value of a to the value of b, then store the result in variable a.
   mul a b - Multiply the value of a by the value of b, then store the result in variable a.
   div a b - Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
   mod a b - Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
   eql a b - If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.
   */
  struct ALU {
    let program: [String]
    var input: ALUInput
    var register: [String: Int] = ["w":0, "x":0, "y":0, "z":0]
    
    mutating func run() {
      for inst in program {
        let parts = inst.components(separatedBy: .whitespaces)
        let cmd  = parts.indices.contains(0) ? parts[0] : nil
        let arg1 = parts.indices.contains(1) ? parts[1] : nil
        let arg2 = parts.indices.contains(2) ? parts[2] : nil
        switch (cmd, arg1, arg2) {
        case let ("inp", a?, _):
          if let i = input.read(), let n = Int(String(i)) {
            register[a] = n
          } else {
            print("failed reading input")
          }
        case let ("add", a?, b?):
          if let aNum = register[a], let bNum = register[b] ?? Int(b) {
            register[a] = aNum + bNum
          }
        case let ("mul", a?, b?):
          if let aNum = register[a], let bNum = register[b] ?? Int(b) {
            register[a] = aNum * bNum
          }
        case let ("div", a?, b?):
          if let aNum = register[a], let bNum = register[b] ?? Int(b) {
            register[a] = aNum / bNum
          }
        case let ("mod", a?, b?):
          if let aNum = register[a], let bNum = register[b] ?? Int(b) {
            register[a] = aNum % bNum
          }
        case let ("eql", a?, b?):
          if let aNum = register[a], let bNum = register[b] ?? Int(b) {
            register[a] = aNum == bNum ? 1 : 0
          }
        default:
          print("uhh oh! found bad instruction")
          break
        }
      }
    }
  }
 
}

