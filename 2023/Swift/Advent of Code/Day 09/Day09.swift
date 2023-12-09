//
//  Day9.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on MM/DD/YY.
//
//  --- Day 9: Mirage Maintenance ---

import Foundation

class Day09: Day {
    func part1() -> String {
        let histories = makeHistories()
        let sum = histories.map { history in
            extrapolatedValue(fromSequence: history)
        }.reduce(0, +)
        return "\(sum)"
    }
    
    func part2() -> String {
        let histories = makeHistories()
        let sum = histories.map { history in
            extrapolatedValue(fromSequence: history, backwards: true)
        }.reduce(0, +)
        return "\(sum)"
    }

    private func makeHistories() -> [[Int]] {
        input.lines().map { line in
            line.components(separatedBy: .whitespaces).compactMap(Int.init)
        }
    }

    private func extrapolatedValue(fromSequence sequence: [Int], backwards: Bool = false) -> Int {
        guard sequence.contains(where: {$0 != 0}) else {
            return 0
        }
        let diffs = zip(sequence, sequence.dropFirst()).map { $0.1 - $0.0 }
        let ev = extrapolatedValue(fromSequence: diffs, backwards: backwards)
        return !backwards ? ev + sequence.last! : sequence.first! - ev
    }
}
