//
//  Day13.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/13/23.
//
//  --- Day 13: Point of Incidence ---

import Foundation

class Day13: Day {
    func part1() -> String {
        let patterns = makePatterns()
        let summary = patterns.map { $0.summarize() }.reduce(0, +)
        return "\(summary)"
    }
    
    func part2() -> String {
        "Not Implemented"
    }

    struct Pattern {
        let pattern: [[Character]]

        init(string: String) {
            pattern = string.lines().map(Array.init)
        }

        enum Direction {
            case vertical, horizontal
        }

        func reflectionStart(direction: Direction) -> Int? {
            let lines: [[Character]]
                switch direction {
            case .vertical:
                lines = pattern[0].indices.map { i in  pattern.map { $0[i] }}
            case .horizontal:
                lines = pattern
            }

            for i in (1..<lines.indices.upperBound) {
                let prev = lines[0..<i]
                let next = lines.dropFirst(i)
                if zip(prev.reversed(), next).allSatisfy({ $0 == $1 }) {
                    return i
                }
            }
            return nil
        }

        func summarize() -> Int {
            (reflectionStart(direction: .vertical) ?? 0) + (100 * (reflectionStart(direction: .horizontal) ?? 0))
        }
    }

    private func makePatterns() -> [Pattern] {
        return input.components(separatedBy: "\n\n").map(Pattern.init(string:))
    }
}
