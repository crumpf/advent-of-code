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
    let computer: IntcodeComputer
    let program: [Int]
    private var phaseRange = 0...0

    init(name: String, program: [Int]) {
        self.name = name
        self.program = program
        self.computer = IntcodeComputer(program: program)
    }

    func lastOutput() -> Int? {
        return computer.output.last
    }

    func run(phaseSetting: Int, inputSignal: Int?, phaseRange: ClosedRange<Int>) -> Int? {
        self.phaseRange = phaseRange
        
        guard Util.isValidPhaseRange(phaseRange), phaseRange.contains(phaseSetting) else {
            print("Error, validating phaseSetting:\(phaseSetting) and phaseRange:\(phaseRange)")
            return nil
        }

        computer.run(input: [phaseSetting, inputSignal ?? 0])
        return computer.output.last
    }

    func resume(inputSignal: Int) -> Int? {
        computer.resume(input: [inputSignal])
        return computer.output.last
    }
}
