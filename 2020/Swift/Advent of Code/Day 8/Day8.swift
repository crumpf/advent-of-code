//
//  Day8.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

struct Instruction {
  let operation: String
  let argument: Int
}

class Day8: Day {
  /// Run your copy of the boot code. Immediately before any instruction is executed a second time, what value is in the accumulator?
  func part1() -> String {
    var accumulator = 0
    let instructions = makeInstructions(input: input)
    var i = 0
    var visited = Set<Int>()
    while i < instructions.count {
      guard !visited.contains(i) else {
        break
      }
      visited.insert(i)
      let inst = instructions[i]
      switch inst.operation {
      case "acc":
        accumulator += inst.argument
        i += 1
      case "jmp":
        i += inst.argument
      case "nop":
        i += 1
      default:
        abort() //oops
      }
    }
    return String(accumulator)
  }
  
  /// Fix the program so that it terminates normally by changing exactly one jmp (to nop) or nop (to jmp). What is the value of the accumulator after the program terminates?
  func part2() -> String {
    let instructions = makeInstructions(input: input)
    for i in instructions.indices {
      if let result = run(instructions, questionableIndex: i) {
        return String(result)
      }
    }
    return "Not found :("
  }
  
  private func makeInstructions(input: String) -> [Instruction] {
    input.lines().map {
      let parts = $0.split(separator: " ")
      return Instruction(operation: String(parts[0]), argument: Int(parts[1])!)
    }
  }
  
  /// returns nil if an infinite loop is found, accumulator result otherwise
  private func run(_ instructions: [Instruction], questionableIndex: Int) -> Int? {
    var accumulator = 0
    var i = 0
    var visited = Set<Int>()
    while i < instructions.count {
      guard !visited.contains(i) else {
        return nil
      }
      visited.insert(i)
      
      let inst = instructions[i]
      var operation = inst.operation
      if questionableIndex == i {
        if operation == "jmp" {
          operation = "nop"
        } else if operation == "nop" {
          operation = "jmp"
        }
      }
      
      switch operation {
      case "acc":
        accumulator += inst.argument
        i += 1
      case "jmp":
        i += inst.argument
      case "nop":
        i += 1
      default:
        abort() //oops
      }
    }
    
    return accumulator
  }
}
