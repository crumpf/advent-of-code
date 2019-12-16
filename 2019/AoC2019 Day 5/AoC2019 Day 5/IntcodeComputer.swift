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

class IntcodeComputer {
    private var buffer: [Int] = []

    func process(_ input: [Int]) throws -> [Int] {
        buffer = input
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
                case .halt:
                    return buffer
                case .input:
                    let p1 = buffer[instructionPointer + 1]
                    // Parameters that an instruction writes to will never be in immediate mode.
                    buffer[p1] = 1 // todo: get input from
                case .output:
                    let p1 = value(at: instructionPointer + 1, mode: codes.parameterModes[0])
                    print("output opcode: value \(p1)")
                    break
                }
                instructionPointer += codes.parameterModes.count + 1
            } catch {
                print("exception found at instruction pointer \(instructionPointer), value \(buffer[instructionPointer]):\n\(error)")
                return []
            }
        }

        return buffer
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
