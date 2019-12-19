//
//  main.swift
//  AoC2019 Day 5
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

var outputSignal: Int?
let phaseRange = 0...4
var maxOutput = 0
var stringDescribingMaxOutput = ""

for num in 0...44444 {
    outputSignal = nil
    let phaseSequence = try? String(format: "%05d", num).map { (c) -> Int in
        guard let num = c.wholeNumberValue, phaseRange.contains(num) else {
            throw IntcodeError.notFound
        }
        return num
    }
    if let phaseSequence = phaseSequence, phaseSequence.count == Set<Int>(phaseSequence).count, phaseSequence.count == amps.count {
        for i in 0..<amps.count {
            outputSignal = amps[i].run(phaseSetting: phaseSequence[i], inputSignal: outputSignal)
        }
        if let outputSignal = outputSignal, outputSignal > maxOutput {
            maxOutput = outputSignal
            stringDescribingMaxOutput = "\(phaseSequence) : \(String(describing: outputSignal))"
        }
    }
}

print(stringDescribingMaxOutput)

