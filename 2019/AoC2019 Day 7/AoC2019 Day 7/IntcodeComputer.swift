//
//  IntcodeComputer.swift
//  AoC2019 Day 5
//
//  Created by Chris Rumpf on 12/15/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

import Foundation

enum Opcode: Int {
    case add = 1
    case multiply = 2
    case input = 3
    case output = 4
    case jumpIfTrue = 5
    case jumpIfFalse = 6
    case lessThan = 7
    case equals = 8
    case halt = 99

    func parameterCount() -> Int {
        switch self {
        case .add:
            return 3
        case .multiply:
            return 3
        case .input:
            return 1
        case .output:
            return 1
        case .jumpIfTrue:
            return 2
        case .jumpIfFalse:
            return 2
        case .lessThan:
            return 3
        case .equals:
            return 3
        case .halt:
            return 0
        }
    }
}

enum ParameterMode: Int {
    case position = 0
    case immediate = 1
}

enum IntcodeError: Error {
    case invalidOpcode
    case invalidParameterMode
    case notFound
}

protocol InputDelegate: AnyObject {
    func input() -> Int
    func output(_ value: Int)
}

class IntcodeComputer {
    weak var inputDelegate: InputDelegate?
    var buffer: [Int] = []
    var output: [Int] = []

    func process(_ input: [Int]) throws -> [Int] {
        buffer = input
        output = []

        var instructionPointer = 0
        while instructionPointer < buffer.count {
            do {
                let codes = try parseValue(buffer[instructionPointer])
                switch codes.opcode {
                case .add:
                    let p1 = value(at: instructionPointer + 1, mode: codes.parameterModes[0])
                    let p2 = value(at: instructionPointer + 2, mode: codes.parameterModes[1])
                    //Parameters that an instruction writes to will never be in immediate mode.
                    let p3 = buffer[instructionPointer + 3]
                    let sum = p1 + p2
                    buffer[p3] = sum
                case .multiply:
                    let p1 = value(at: instructionPointer + 1, mode: codes.parameterModes[0])
                    let p2 = value(at: instructionPointer + 2, mode: codes.parameterModes[1])
                    // Parameters that an instruction writes to will never be in immediate mode.
                    let p3 = buffer[instructionPointer + 3]
                    let product = p1 * p2
                    buffer[p3] = product
                case .input:
                    // Parameters that an instruction writes to will never be in immediate mode.
                    let p1 = buffer[instructionPointer + 1]
                    var suppliedInput = 0
                    if let inputDelegate = inputDelegate {
                        suppliedInput = inputDelegate.input()
                    } else {
                        print("Enter input: ")
                        guard let read = readLine(), let toInt = Int(read) else {
                            print("Error with user input")
                            return []
                        }
                        suppliedInput = toInt
                    }
                    buffer[p1] = suppliedInput
                case .output:
                    let p1 = value(at: instructionPointer + 1, mode: codes.parameterModes[0])
                    if let inputDelegate = inputDelegate {
                        inputDelegate.output(p1)
                    } else {
                        print("execution output: \(p1)")
                    }
                    output.append(p1)
                case .jumpIfTrue:
                    let p1 = value(at: instructionPointer + 1, mode: codes.parameterModes[0])
                    if p1 != 0 {
                        let p2 = value(at: instructionPointer + 2, mode: codes.parameterModes[1])
                        instructionPointer = p2
                        continue
                    }
                case .jumpIfFalse:
                    let p1 = value(at: instructionPointer + 1, mode: codes.parameterModes[0])
                    if p1 == 0 {
                        let p2 = value(at: instructionPointer + 2, mode: codes.parameterModes[1])
                        instructionPointer = p2
                        continue
                    }
                case .lessThan:
                    let p1 = value(at: instructionPointer + 1, mode: codes.parameterModes[0])
                    let p2 = value(at: instructionPointer + 2, mode: codes.parameterModes[1])
                    // Parameters that an instruction writes to will never be in immediate mode.
                    let p3 = buffer[instructionPointer + 3]
                    buffer[p3] = p1 < p2 ? 1 : 0
                case .equals:
                    let p1 = value(at: instructionPointer + 1, mode: codes.parameterModes[0])
                    let p2 = value(at: instructionPointer + 2, mode: codes.parameterModes[1])
                    // Parameters that an instruction writes to will never be in immediate mode.
                    let p3 = buffer[instructionPointer + 3]
                    buffer[p3] = p1 == p2 ? 1 : 0
                case .halt:
                    return output
                }
                instructionPointer += codes.parameterModes.count + 1
            } catch {
                print("Exception found at instruction pointer \(instructionPointer), value \(buffer[instructionPointer]):\n\(error)")
                return []
            }
        }

        return output
    }

    func parseValue(_ value: Int) throws -> (opcode: Opcode, parameterModes: [ParameterMode]) {
        // The opcode is a two-digit number based only on the ones and tens digit of the value
        guard let opcode = Opcode(rawValue: value % 100) else {
            throw IntcodeError.invalidOpcode
        }
        // Parameter modes are single digits, one per parameter, read right-to-left from the opcode: the first parameter's mode is in the hundreds digit, the second parameter's mode is in the thousands digit, the third parameter's mode is in the ten-thousands digit, and so on. Any missing modes are 0.
        var parameterModes: [ParameterMode] = []
        for i in 0..<opcode.parameterCount() {
            let powOf10 = Int(pow(10.0, Double(2 + i)))
            guard let mode = ParameterMode(rawValue: (value / powOf10) % 10) else {
                throw IntcodeError.invalidParameterMode
            }
            parameterModes.append(mode)
        }

        return (opcode, parameterModes)
    }

    func value(at index: Int, mode: ParameterMode) -> Int {
        let instruction = buffer[index]
        switch mode {
        case .position:
            return buffer[instruction]
        case .immediate:
            return instruction
        }
    }
}
