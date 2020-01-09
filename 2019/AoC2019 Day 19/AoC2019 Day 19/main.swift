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

class BeamComputer {
    let computer: IntcodeComputer

    init(program: [Int]) {
        computer = IntcodeComputer(program: program)
    }

    func isBeamAt(x: Int, y: Int) -> Bool {
        computer.reset()
        while computer.state != .waitingForInput {
            // get ready for input
            _ = computer.run(input: [])
        }
        if let output = computer.run(input: [x, y]) {
            return output == 1
        }
        return false
    }
}

// How many points are affected by the tractor beam in the 50x50 area closest to the emitter
func part1() -> Int? {
    let program = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }
    let computer = BeamComputer(program: program)


    var map: [[String]] = Array(repeating: Array(repeating: ".", count: 50), count: 50)
    var beam = Set<Location>()

    for row in 0..<50 {
        for col in 0..<50 {
            if computer.isBeamAt(x: col, y: row) {
                beam.insert(Location(col, row))
                map[row][col] = "#"
            }
        }
    }

    for (i, row) in map.enumerated() {
        print("\(i)\(row.joined())")
    }

    return beam.count
}

print("PART 1")
print("points affected: \(part1())")

// Find the 100x100 square closest to the emitter that fits entirely within the tractor beam; within that square, find the point closest to the emitter. What value do you get if you take that point's X coordinate, multiply it by 10000, then add the point's Y coordinate?
func part2(width: Int, height: Int) -> Location {
    let program = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }
    let computer = BeamComputer(program: program)

    var row = max(5, height - 1) // start at first possible maxY value, but rows in 1...4 don't appear to have any beam locations
    var col = 0
    while true {
        var minColFound = false
        while !minColFound {
            if computer.isBeamAt(x: col, y: row) {
                minColFound = true
            } else {
                col += 1
            }
        }
        // (minX, maxY) found, now check for (maxX, minY) in beam
        if computer.isBeamAt(x: col + (width - 1), y: row - (height - 1)) {
            break
        } else {
            row += 1
        }
    }

    // square closest to the emitter
    return Location(col, row - (height - 1))
}

print("PART 2")
let point = part2(width: 100, height: 100)
print("point: \(point)")
print("answer: \(point.x * 10000 + point.y)")
