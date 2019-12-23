//
//  main.swift
//  AoC2019 Day 7
//
//  Created by Chris Rumpf on 12/14/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

// https://adventofcode.com/2019/day/5

import Foundation

var str = "Advent of Code 2019, Day 5"
print(str)

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

let input = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }
let amps = ["A","B","C","D","E"].map { Amplifier(name: "Amp\($0)", program: input) }

func findMaxOutput1(amps: [Amplifier], range: ClosedRange<Int>) -> (sequence: [Int], output: Int) {
    var outputSignal: Int?
    var maxOutput = Int.min
    var result: (sequence: [Int], output: Int) = ([], 0)
    if let sequences = Util.getPhasePermutations(range: range) {
        for seq in sequences {
            outputSignal = nil
            for i in 0..<seq.count {
                outputSignal = amps[i].run(phaseSetting: seq[i], inputSignal: outputSignal, phaseRange: range)
            }
            if let outputSignal = outputSignal, outputSignal > maxOutput {
                maxOutput = outputSignal
                result = (seq, outputSignal)
            }
        }
    }

    return result
}


let part1 = findMaxOutput1(amps: amps, range: 0...4)

print("Part1 Answer: \(part1.sequence) : \(part1.output)")

func findMaxOutput2(amps: [Amplifier], range: ClosedRange<Int>) -> (sequence: [Int], output: Int) {
    var result: (sequence: [Int], output: Int) = ([], 0)
    guard let sequences = Util.getPhasePermutations(range: range) else {
        return result
    }

    var outputSignal: Int?
    var maxOutput = Int.min
    for seq in sequences {
        outputSignal = nil
        // todo: this is ultra-dirty because there's an implicit link between the sizes
        // of the sequence count and the # of amps. Definitely need to refactor this,
        // but going to keep moving for now so I can keep progressing through the
        // Advent of Code
        for i in 0..<seq.count {
            outputSignal = amps[i].run(phaseSetting: seq[i], inputSignal: outputSignal, phaseRange: range)
        }
        while amps[4].computer.state != .halted {
            amps[0].resume(inputSignal: amps[4].lastOutput()!)
            amps[1].resume(inputSignal: amps[0].lastOutput()!)
            amps[2].resume(inputSignal: amps[1].lastOutput()!)
            amps[3].resume(inputSignal: amps[2].lastOutput()!)
            amps[4].resume(inputSignal: amps[3].lastOutput()!)
        }
        if let outputSignal = amps[4].lastOutput(), outputSignal > maxOutput {
            maxOutput = outputSignal
            result = (seq, outputSignal)
        }
    }

    return result
}

let part2 = findMaxOutput2(amps: amps, range: 5...9)

print("Part2 Answer: \(part2.sequence) : \(part2.output)")
