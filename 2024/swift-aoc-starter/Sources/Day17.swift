import Algorithms
import Foundation

struct Day17: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func part1() -> Any {
    let program = Program(data: data)
    var computer = Computer()
    return computer.run(program).map(String.init).joined(separator: ",")
  }

  func part2() -> Any {
    0
  }

  struct Program {
    init(data: String) {
      let (_, aString) = data.matches(of: /Register A: (\d+)/).first!.output
      let (_, bString) = data.matches(of: /Register B: (\d+)/).first!.output
      let (_, cString) = data.matches(of: /Register C: (\d+)/).first!.output
      let (_, programString) = data.matches(of: /Program: (.+)/).first!.output
      a = Int(aString)!
      b = Int(bString)!
      c = Int(cString)!
      program = programString.split(separator: ",").compactMap { Int($0) }
    }

    let a, b, c: Int
    let program: [Int]
  }

  struct Computer {
    var a = 0, b = 0, c = 0

    mutating func run(_ program: Program) -> [Int] {
      var output = [Int]()
      a = program.a
      b = program.b
      c = program.c
      var instructionPointer = 0
      while true {
        guard program.program.indices.contains(instructionPointer) else { return output }
        let opcode = program.program[instructionPointer]
        guard program.program.indices.contains(instructionPointer + 1) else { return output }
        let operand = program.program[instructionPointer + 1]
        switch opcode {
        case 0: //adv
          a = a / Int("\(pow(2, comboOperand(operand)))")!
        case 1: // bxl
          b = b ^ operand
        case 2: //bst
          b = comboOperand(operand) % 8
        case 3: //jnz
          if a != 0 {
            instructionPointer = operand
            continue
          }
        case 4: //bxc
          b = b ^ c
        case 5: //out
          output.append(comboOperand(operand) % 8)
        case 6: //bdv
          b = a / Int("\(pow(2, comboOperand(operand)))")!
        case 7: //cdv
          c = a / Int("\(pow(2, comboOperand(operand)))")!
        default: print("ONOZ instructionPointer:\(instructionPointer) opcode:\(opcode) operand:\(operand)")
        }
        instructionPointer += 2
      }
      return output
    }

    func comboOperand(_ operand: Int) -> Int {
      switch operand {
      case 4: return a
      case 5: return b
      case 6: return c
      case 7: abort()
      default: return operand
      }
    }
  }
}
