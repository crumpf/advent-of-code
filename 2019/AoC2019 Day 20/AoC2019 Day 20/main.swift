//
//  main.swift
//  AoC2019 Day 20
//
//  Created by Chris Rumpf on 1/10/20.
//  Copyright © 2020 Chris Rumpf. All rights reserved.
//

import Foundation

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

// --- Day 20: Donut Maze ---

// easier to work with [[String]] or [[Character]]?
//let map = fileInput.components(separatedBy: "\n").map { $0.map { String($0) } }
let map = fileInput.components(separatedBy: "\n").map { Array<Character>($0) }

for row in map {
    print(row.map { String($0) }.joined())
}

extension CharacterSet {
    func containsUnicodeScalars(of character: Character) -> Bool {
        return character.unicodeScalars.allSatisfy(contains(_:))
    }
}

func letterAt(x: Int, y: Int) -> Character? {
    guard map.indices.contains(y), map[y].indices.contains(x), CharacterSet.uppercaseLetters.containsUnicodeScalars(of: map[y][x]) else { return nil }
    return map[y][x]
}

func hasOpeningAt(x: Int, y: Int) -> Bool {
    guard map.indices.contains(y), map[y].indices.contains(x) else { return false }
    return ".".contains(map[y][x])
}

typealias XY = SIMD2<Int>

struct Door {
    let name: String
    let loc: XY
}

// find magic doors
for (y, row) in map.enumerated() {
    guard y < map.count - 2 else { continue }
    for (x, c) in row.enumerated() {
        guard x < row.count - 1 else { continue }
        if CharacterSet.uppercaseLetters.containsUnicodeScalars(of: c) {
            if let bottom = letterAt(x: x, y: y + 1) {
                // found vertical door tag
                let name = String([c, bottom])
                let loc = hasOpeningAt(x: x, y: y - 1) ? XY(x, y-1) : XY(x, y+2)
            } else if let right = letterAt(x: x + 1, y: y) {
                // found horizontal door tag
                let name = String([c, right])
                let loc = hasOpeningAt(x: x - 1, y: y) ? XY(x-1, y) : XY(x+2, y)
            }
        }
    }
}
