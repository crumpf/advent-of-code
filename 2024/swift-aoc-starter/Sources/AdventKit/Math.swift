//
//  Math.swift
//  Advent of Code
//
//  Created by Chris Rumpf on 12/8/23.
//

import Foundation

struct Math {
    /// Greatest Common Divisor
    static func gcd(_ a: Int, _ b: Int) -> Int {
        // Euclidean algorithm
        if b == 0 {
            return a
        }
        return gcd(b, a % b)
    }

    /// Least Common Multiple
    static func lcm(_ a: Int, _ b: Int) -> Int {
        a * b / gcd(a, b)
    }
}
