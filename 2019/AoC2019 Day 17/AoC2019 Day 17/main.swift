//
//  main.swift
//  AoC2019 Day 17
//
//  Created by Chris Rumpf on 1/6/20.
//  Copyright © 2020 Chris Rumpf. All rights reserved.
//

import Foundation

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

// --- Day 17: Set and Forget ---

func characterFromScalar(_ scalar: Int) -> Character {
    Character(UnicodeScalar(scalar)!)
}

typealias Location = SIMD2<Int>

func part1() -> [[String]] {
    let program = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }
    let computer = IntcodeComputer(program: program)

    // build map

    var map: [[String]] = []
    var currentRow: [String] = []
    while computer.state != .halted {
        if let output = computer.run(input: []) {
            if output == 10 {
                map.append(currentRow)
                currentRow = []
            } else if let scalar = UnicodeScalar(output) {
                let s = String(Character(scalar))
                currentRow.append(s)
            }
        }
    }

    // find intersections

    var intersections = Set<Location>()
    for (rowi, row) in map.enumerated() {
        guard (1..<map.count-2).contains(rowi) else { continue }
        for (coli, col) in row.enumerated() {
            guard (1..<row.count-1).contains(coli) else { continue }
            if col == "#" && map[rowi-1][coli] == "#" && map[rowi][coli-1] == "#" && map[rowi][coli+1] == "#" && map[rowi+1][coli] == "#" {
                map[rowi][coli] = "O"
                intersections.insert(Location(coli, rowi))
            }
        }
    }

    for row in map {
        print(row.joined())
    }

    print("Sum of alignment parameters:")
    print(intersections.reduce(0) { (res, loc) -> Int in
        res + loc.x * loc.y
    })

    return map
}
let p1 = part1()

print("\nNow for PART 2\n")

func part2() -> ([[String]], Int?) {
    var program = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }
    // Force the vacuum robot to wake up by changing the value in your ASCII program at address 0 from 1 to 2
    program[0] = 2
    let computer = IntcodeComputer(program: program)

    // build map

    var map: [[String]] = []
    var currentRow: [String] = []
    while computer.state != .waitingForInput {
        if let output = computer.run(input: []) {
            if output == 10 {
                map.append(currentRow)
                currentRow = []
            } else if let scalar = UnicodeScalar(output) {
                let s = String(Character(scalar))
                currentRow.append(s)
            }
        }
    }
    for row in map {
        print(row.joined())
    }

    let fnMain = "A,B,A,C,B,C,B,C,A,B"
    let fnA = "L,6,L,4,R,8"
    let fnB = "R,8,L,6,L,4,L,10,R,8"
    let fnC = "L,4,R,4,L,4,R,8"

    var main = fnMain.components(separatedBy: ",").flatMap { $0.map { Int($0.asciiValue!) } + [44] }
    main[main.count - 1] = 10
    var a = fnA.components(separatedBy: ",").flatMap { $0.map { Int($0.asciiValue!) } + [44] }
    a[a.count - 1] = 10
    var b = fnB.components(separatedBy: ",").flatMap { $0.map { Int($0.asciiValue!) } + [44] }
    b[b.count - 1] = 10
    var c = fnC.components(separatedBy: ",").flatMap { $0.map { Int($0.asciiValue!) } + [44] }
    c[c.count - 1] = 10

    var prompt: [Character] = []
    var output: Int?
    var result = 0

    for routine in [main, a, b, c] {
        while computer.state != .waitingForInput {
            if let output = computer.run(input: []) {
                prompt.append(Character(UnicodeScalar(output)!))
            }
        }
        print(String(prompt))
        prompt.removeAll()
        if let output = computer.run(input: routine) {
            prompt.append(Character(UnicodeScalar(output)!))
        }
    }

    while computer.state != .waitingForInput {
        if let output = computer.run(input: []) {
            prompt.append(Character(UnicodeScalar(output)!))
        }
    }
    print(String(prompt))
    prompt.removeAll()
    output = computer.run(input: [Int(Character("n").asciiValue!), 10])

    while computer.state != .halted {
        if let output = computer.run(input: []) {
            if let scalar = UnicodeScalar(output) {
                if scalar.isASCII {
                    prompt.append(Character(scalar))
                } else {
                    result = output
                }
            }
        }
    }

    print(String(prompt))

    return (map, result)
}
let p2 = part2()

print("dust collected = \(String(describing: p2.1))")
