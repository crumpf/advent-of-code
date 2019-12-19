//
//  Amplifier.swift
//  AoC2019 Day 7
//
//  Created by Chris Rumpf on 12/19/19.
//  Copyright © 2019 Genesys. All rights reserved.
//

import Foundation

class Amplifier {
    let name: String
    let computer = IntcodeComputer()
    let program: [Int]
    private var inputs: [Int?] = []
    private var inputIndex = 0

    init(name: String, program: [Int]) {
        self.name = name
        self.program = program
        computer.inputDelegate = self
    }

    func run(phaseSetting: Int, inputSignal: Int?) -> Int? {
        inputs = [phaseSetting, inputSignal ?? 0]
        inputIndex = 0
        do {
            let result = try computer.process(program)
            print("Amplifier \(name): Result:", result)
            return result.last
        } catch {
            print("Amplifier \(name): Error:", error)
        }

        return nil
    }
}

extension Amplifier: InputDelegate {
    func input() -> Int {
        var inputToSupply: Int? = nil

        if inputs.indices.contains(inputIndex) {
            inputToSupply = inputs[inputIndex]
        }

        if inputToSupply == nil {
            if inputIndex == 0 {
                print("Amplifier \(name): Enter phase setting (0...4):", separator: " ", terminator: " ")
            } else {
                print("Amplifier \(name): Enter input signal:", separator: " ", terminator: " ")
            }
            guard let read = readLine(), let toInt = Int(read) else {
                print("Error with input. Must be an integer.")
                exit(0)
            }
            if inputIndex == 0 && !(0...4).contains(toInt) {
                print("Error with input. Input must be in range (0...4)")
                exit(0)
            }
            inputToSupply = toInt
        }

        if let inputToSupply = inputToSupply {
            if inputIndex == 0 {
                print("Amplifier \(name): input phase setting: \(inputToSupply)")
            } else {
                print("Amplifier \(name): input signal: \(inputToSupply)")
            }
            inputIndex += 1
            return inputToSupply
        } else {
            print("Error with input.")
            exit(0)
        }
    }

    func output(_ value: Int) {
        print("Amplifier \(name): Output: \(value)")
    }
}
