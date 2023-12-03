//
//  Ranges.swift
//  AdventUnitTests
//
//  Created by Christopher Rumpf on 12/16/22.
//

import Foundation

extension Array where Element == ClosedRange<Int> {
    func mergeOverlapping() -> [Element] {
        guard !self.isEmpty else {
            return self
        }
        var overlapping = [ClosedRange<Int>]()
        let sorted = self.sorted { $0.lowerBound < $1.lowerBound }
        var accumulator = sorted.first!
        for range in sorted {
            if accumulator.contains(range.lowerBound) {
                accumulator = accumulator.lowerBound...Swift.max(accumulator.upperBound, range.upperBound)
            } else {
                overlapping.append(accumulator)
                accumulator = range
            }
        }
        overlapping.append(accumulator)
        return overlapping
    }
}
