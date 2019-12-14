// https://adventofcode.com/2019/day/2

import Foundation

var str = "Advent of Code 2019, Day 2"
print(str)

var input: String

if let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt") {
    print("file from bundle \(fileURL)")
    input = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
} else {
    let fileURL = URL(fileURLWithPath: "./input.txt")
    print("file from disk \(fileURL)")
    input = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
}

print(input)

let program = input.components(separatedBy: ",").compactMap { Int($0) }

enum Opcode: Int {
    case add = 1
    case multiply = 2
    case halt = 99
}

enum OpcodeError: Error {
    case invalidOpcode
    case notFound
}

func processIntcodeProgram(_ program: [Int]) throws -> [Int] {
    var result = program
    var instructionPointer = 0
    var instructionLength = 1 // the instruction length is the opcode + the number of paramters, so (1 opcode + X parameters)
    while instructionPointer < result.count {
        let opcode = Opcode(rawValue: result[instructionPointer])

        switch opcode {
        case .add:
            instructionLength = 4
            let firstIndex = result[instructionPointer + 1]
            let secondIndex = result[instructionPointer + 2]
            let position = result[instructionPointer + 3]
            let sum = result[firstIndex] + result[secondIndex]
            result[position] = sum
        case .multiply:
            instructionLength = 4
            let firstIndex = result[instructionPointer + 1]
            let secondIndex = result[instructionPointer + 2]
            let position = result[instructionPointer + 3]
            let product = result[firstIndex] * result[secondIndex]
            result[position] = product
        case .halt:
            instructionLength = 1
//            print("opcode halt found at instruction pointer \(instructionPointer)")
            break
        case .none:
            print("opcode exception found at instruction pointer \(instructionPointer), value \(result[instructionPointer])")
            throw OpcodeError.invalidOpcode
        }

        instructionPointer += 4
    }

    return result
}

let example1 = [1,9,10,3,2,3,11,0,99,30,40,50]
let example2 = [1,0,0,0,99]
let example3 = [2,3,0,3,99]
let example4 = [2,4,4,5,99,0]
let example5 = [1,1,1,4,99,5,6,0,99]

do {
    var executedProgram = try processIntcodeProgram(example1)
    print("\(executedProgram)")
    executedProgram = try processIntcodeProgram(example2)
    print("\(executedProgram)")
    executedProgram = try processIntcodeProgram(example3)
    print("\(executedProgram)")
    executedProgram = try processIntcodeProgram(example4)
    print("\(executedProgram)")
    executedProgram = try processIntcodeProgram(example5)
    print("\(executedProgram)")

    print("Running reset program to 1202 program alarm state")
    var resetProgram = program
    resetProgram[1] = 12
    resetProgram[2] = 2
    executedProgram = try processIntcodeProgram(resetProgram)
    print("\(executedProgram)")
    print("value left at postion 0: \(executedProgram[0])")
    // correct answer = 3267740
} catch {
    print("\(error)")
}

// PART 2
// determine what pair of inputs produces the output 19690720
print("PART 2")

func findNounAndVerbProducingOutput(_ output: Int, program: [Int]) throws -> (Int, Int) {
    for noun in 0...99 {
        for verb in 0...99 {
            var p = program
            p[1] = noun
            p[2] = verb
            let executed = try processIntcodeProgram(p)
            if executed[0] == output {
                return (noun, verb)
            }
        }
    }

    throw OpcodeError.notFound
}

if let nounVerb = try? findNounAndVerbProducingOutput(19690720, program: program) {
    print("\(nounVerb)")
} else {
    print("not found")
}
