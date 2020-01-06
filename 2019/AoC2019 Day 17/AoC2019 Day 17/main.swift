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

func part1() {
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
        print(row.reduce("", { (result, s) -> String in
            result + s
        }))
    }

    print("Sum of alignment parameters:")
    print(intersections.reduce(0) { (res, loc) -> Int in
        res + loc.x * loc.y
    })
}
part1()
