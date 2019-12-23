//
//  Utils.swift
//  AoC2019 Day 7
//
//  Created by Chris Rumpf on 12/19/19.
//  Copyright © 2019 Genesys. All rights reserved.
//

import Foundation

final class Util {
    // TODO: this is hacky, it assumes that the range contains 5 digits
    static func getPhasePermutations(range: ClosedRange<Int>) -> [[Int]]? {
        guard Util.isValidPhaseRange(range) else {
            return nil
        }

        var permutations: [[Int]] = []
        let lower = Int(String(repeating: "\(range.lowerBound)", count: amps.count)) ?? 0
        let upper = Int(String(repeating: "\(range.upperBound)", count: amps.count)) ?? 0

        for num in lower...upper {
            let phaseSequence = try? String(format: "%05d", num).map { (c) -> Int in
                guard let num = c.wholeNumberValue, range.contains(num) else {
                    throw NSError(domain: "", code: -1, userInfo: nil)
                }
                return num
            }
            if let phaseSequence = phaseSequence, phaseSequence.count == Set<Int>(phaseSequence).count {
                permutations.append(phaseSequence)
            }
        }

        return permutations
    }

    static func isValidPhaseRange(_ range: ClosedRange<Int>) -> Bool {
        guard (0...9).contains(range.lowerBound), (0...9).contains(range.upperBound) else {
            return false
        }
        return true
    }
}
