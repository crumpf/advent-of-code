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
        let patterns = makePatterns()
        let summary = patterns.map { $0.summarizedWithSmudgeFixed() }.reduce(0, +)
        return "\(summary)"
    }

    struct Pattern {
        let pattern: [[Character]]
        let id: Int

        init(string: String, id: Int) {
            pattern = string.lines().map(Array.init)
            self.id = id
        }

        enum Direction {
            case vertical, horizontal
        }

        func columns(of lines: [[Character]]) -> [[Character]] {
            lines[0].indices.map { i in  lines.map { $0[i] }}
        }

        func reflectionIndex(direction: Direction) -> Int {
            let lines: [[Character]]
            switch direction {
            case .vertical:
                lines = columns(of: pattern)
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
            return 0
        }

        func reflectionIndex(direction: Direction, change: (x:Int, y:Int), differentThan: Int) -> Int {
            var lines = pattern
            lines[change.y][change.x] = lines[change.y][change.x] == "#" ? "." : "#"
            if direction == .vertical {
                lines = columns(of: lines)
            }

            for i in (1..<lines.indices.upperBound) {
                let prev = lines[0..<i]
                let next = lines.dropFirst(i)
                if zip(prev.reversed(), next).allSatisfy({ $0 == $1 }) && i != differentThan {
                    return i
                }
            }
            return 0
        }

        func summarize() -> Int {
            summary(v: reflectionIndex(direction: .vertical), h: reflectionIndex(direction: .horizontal))
        }

        func summarizedWithSmudgeFixed() -> Int {
            let smudgeV = reflectionIndex(direction: .vertical)
            let smudgeH = reflectionIndex(direction: .horizontal)
            for (y, line) in pattern.enumerated() {
                for x in line.indices {
                    let fixV = reflectionIndex(direction: .vertical, change: (x,y), differentThan: smudgeV)
                    let fixH = reflectionIndex(direction: .horizontal, change: (x,y), differentThan: smudgeH)
                    if fixV > 0 || fixH > 0 {
                        return summary(v: fixV, h: fixH)
                    }
                }
            }
            abort() // !oh no, there's supposed to be a smudge in every pattern
        }

        private func summary(v: Int, h: Int) -> Int {
            v + 100 * h
        }
    }

    private func makePatterns() -> [Pattern] {
        return input.components(separatedBy: "\n\n").enumerated().map { Pattern.init(string:$0.element, id: $0.offset) }
    }
}
