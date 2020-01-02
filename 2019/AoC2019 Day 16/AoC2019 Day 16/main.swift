//
//  main.swift
//  AoC2019 Day 16
//
//  Created by Chris Rumpf on 1/1/20.
//  Copyright © 2020 Chris Rumpf. All rights reserved.
//

import Foundation

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

// --- Day 16: Flawed Frequency Transmission ---

func fft(input: [Int], pattern: [Int]) -> Int {
    let numRepeats = input.count / pattern.count
    let repeating = pattern.dropFirst() + Array(repeating: pattern, count: numRepeats).flatMap { $0 }
    let sum = zip(input, repeating).map { $0 * $1 }.reduce(0) { $0 + $1 }
    return abs(sum) % 10
}

func patternForPosition(_ position: Int, basePattern: [Int]) -> [Int] {
    basePattern.flatMap { Array(repeating: $0, count: position + 1) }
}

func part1() {
    let input = fileInput.components(separatedBy: "\n")[0].compactMap { Int(String($0)) }
    let basePattern = [0, 1, 0, -1]

    var outputSignal = input
    for phase in 1...100 {
        let inputSignal = outputSignal
        outputSignal.removeAll()
        for position in 0..<inputSignal.count {
            let pattern = patternForPosition(position, basePattern: basePattern)
            outputSignal.append(fft(input: inputSignal, pattern: pattern))
        }
        print("after phase \(phase): first 8 outputSignal \(outputSignal.prefix(8))")
    }

}

part1()
