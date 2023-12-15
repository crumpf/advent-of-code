//
//  DayX.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on MM/DD/YY.
//
//  --- Day 15: Lens Library ---

import Foundation

class Day15: Day {
    func part1() -> String {
        let seqs = makeSequences()
        let sum = seqs.map(HASH(_:)).reduce(0, +)
        return "\(sum)"
    }
    
    func part2() -> String {
        "Not Implemented"
    }

    private func makeSequences() -> [String] {
        input.split(separator: ",").map { String($0) }
    }

    func HASH(_ s: String) -> Int {
        var currentValue = 0
        for c in s {
            if c.isNewline { continue }
            guard let ascii = c.asciiValue else {
                abort() // unexpected non-ascii found
            }
            currentValue += Int(ascii)
            currentValue *= 17
            currentValue = currentValue % 256
        }
        return currentValue
    }
}
