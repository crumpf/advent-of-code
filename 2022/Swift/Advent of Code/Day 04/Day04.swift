//
//  Day04.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/04/22.
//

import Foundation

class Day04: Day {
    
    func part1() -> String {
        "\(numberOfAssignmentPairsWhereOneRangeFullyContainsTheOther())"
    }
    
    func part2() -> String {
        "\(numberOfAssignmentPairsWhereRangesOverlap())"
    }
    
    private func numberOfAssignmentPairsWhereOneRangeFullyContainsTheOther() -> Int {
        assignmentPairs.reduce(0) { partialResult, pair in
            let isFullyContained = (pair.0.contains(pair.1.lowerBound) && pair.0.contains(pair.1.upperBound))
            || (pair.1.contains(pair.0.lowerBound) && pair.1.contains(pair.0.upperBound))
            return partialResult + (isFullyContained ? 1 : 0)
        }
    }
    
    private func numberOfAssignmentPairsWhereRangesOverlap() -> Int {
        assignmentPairs.reduce(0) { partialResult, pair in
            pair.0.overlaps(pair.1) ? partialResult + 1 : partialResult
        }
    }
    
    private lazy var assignmentPairs = input.lines().map {
        let ranges = $0.split(separator: ",").compactMap { makeRange(string: String($0)) }
        return (ranges[0], ranges[1])
    }
    
    private func makeRange(string: String) -> ClosedRange<Int>? {
        let components = string.components(separatedBy: "-")
        guard components.count == 2,
              let lower = Int(components[0]),
              let upper = Int(components[1]) else {
            return nil
        }
        return lower...upper
    }
}
