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
        "Not Implemented"
    }

    private func makeHistories() -> [[Int]] {
        input.lines().map { line in
            line.components(separatedBy: .whitespaces).compactMap(Int.init)
        }
    }

    private func extrapolatedValue(fromSequence sequence: [Int]) -> Int {
        guard sequence.contains(where: {$0 != 0}) else {
            return 0
        }
        let diffs = differences(sequence)
        let ev = extrapolatedValue(fromSequence: diffs)
        return ev + sequence.last!
    }

    private func differences(_ sequence: [Int]) -> [Int] {
        guard sequence.count > 1 else { abort() }
        var diffs = [Int]()
        for i in 1..<sequence.count {
            diffs.append(sequence[i]-sequence[i-1])
        }
        return diffs
    }
}
