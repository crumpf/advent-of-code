//
//  main.swift
//  AoC2019 Day 19
//
//  Created by Chris Rumpf on 1/9/20.
//  Copyright © 2020 Chris Rumpf. All rights reserved.
//

import Foundation

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

// --- Day 19: Tractor Beam ---

// The program uses two input instructions to request the X and Y position to which the drone should be deployed. Negative numbers are invalid and will confuse the drone; all numbers should be zero or positive.
// Then, the program will output whether the drone is stationary (0) or being pulled by something (1)

typealias Location = SIMD2<Int>

// How many points are affected by the tractor beam in the 50x50 area closest to the emitter
func part1() -> Int? {
    let program = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }
    let computer = IntcodeComputer(program: program)

    var map: [[String]] = Array(repeating: Array(repeating: ".", count: 50), count: 50)
    var beam = Set<Location>()
    var output: Int?

    for row in 0..<50 {
        for col in 0..<50 {
            computer.reset()
            while computer.state != .waitingForInput {
                output = computer.run(input: [])
            }
            output = computer.run(input: [col, row])
            if let output = output, output == 1 {
                beam.insert(Location(col, row))
                map[row][col] = "#"
            }
        }
    }

    for row in map {
        print(row.joined())
    }

    return beam.count
}

print("PART 1")
print("points affected: \(part1())")
