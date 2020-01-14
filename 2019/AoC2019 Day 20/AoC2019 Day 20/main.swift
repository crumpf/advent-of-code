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

func letterRightOf(x: Int, y: Int) -> Character? {
    guard y < map.count, x < map[y].count - 1, CharacterSet.uppercaseLetters.containsUnicodeScalars(of: map[y][x+1]) else { return nil }
    return map[y][x+1]
}

func letterBottomOf(x: Int, y: Int) -> Character? {
    guard y < map.count - 1, x < map[y].count, CharacterSet.uppercaseLetters.containsUnicodeScalars(of: map[y+1][x]) else { return nil }
    return map[y+1][x]
}

typealias XY = SIMD2<Int>

var doors: [XY:String] = [:]

// find magic doors
for (y, row) in map.enumerated() {
    guard y < map.count - 2 else { continue }
    for (x, c) in row.enumerated() {
        guard x < row.count - 1 else { continue }
        if CharacterSet.uppercaseLetters.containsUnicodeScalars(of: c) {
            if let right = letterRightOf(x: x, y: y) {
                // found vertical door tag
                let doorName = String([c, right])
                doors[XY(x, y)] = doorName
                doors[XY(x+1, y)] = doorName
            } else if let bottom = letterBottomOf(x: x, y: y) {
                // found horizontal door tag
                let doorName = String([c, bottom])
                doors[XY(x, y)] = doorName
                doors[XY(x, y+1)] = doorName
            }
        }
    }
}
