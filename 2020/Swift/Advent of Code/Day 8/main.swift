//
//  main.swift
//  Day Puzzle Template
//
//  Created by Christopher Rumpf on 12/8/20.
//

import Foundation

struct Instruction {
  let operation: String
  let argument: Int
}

class Day8 {
  func makeInstructions(input: String) -> [Instruction] {
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

extension Day8: Puzzle {
  func part1(withInput input: String) -> String {
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
  
  func part2(withInput input: String) -> String {
    let instructions = makeInstructions(input: input)
    for i in instructions.indices {
      if let result = run(instructions, questionableIndex: i) {
        return String(result)
      }
    }
    return "Not found :("
  }
}

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day8()

let testInput = """
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
"""

print("====Test 1====")
let test1 = day.part1(withInput: testInput)
print(test1)

print("====Test 2====")
let test2 = day.part2(withInput: testInput)
print(test2)

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.raw)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.raw)
print(part2)
