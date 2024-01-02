//
//  Day24.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on MM/DD/YY.
//
//  --- Day 24: Never Tell Me The Odds ---

import Foundation
import RegexBuilder

class Day24: Day {
    func part1() -> String {
        return "\(intersections(range: 200_000_000_000_000...400_000_000_000_000))"
    }
    
    func part2() -> String {
        "Not Implemented"
    }

    func intersections(range: ClosedRange<Int>) -> Int {
        let stones = makeHailstones()

        let lineSegements = stones.map { hs in
            let pt1 = hs.position
            let pt2 = SIMD3(
                hs.position.x + hs.velocity.x * Double(range.upperBound),
                hs.position.y + hs.velocity.y * Double(range.upperBound),
                hs.position.z + hs.velocity.z * Double(range.upperBound)
            )
            return (pt1, pt2)
        }

        var count = 0
        for (i, seg1) in lineSegements.enumerated() {
            for seg2 in lineSegements.dropFirst(i + 1) {
                if let intersection = linesCross(
                    start1: SIMD2(seg1.0.x, seg1.0.y),
                    end1: SIMD2(seg1.1.x, seg1.1.y),
                    start2: SIMD2(seg2.0.x, seg2.0.y),
                    end2: SIMD2(seg2.1.x, seg2.1.y)
                ) {
                    if intersection.x >= Double(range.lowerBound) && intersection.x <= Double(range.upperBound) &&
                        intersection.y >= Double(range.lowerBound) && intersection.y <= Double(range.upperBound) {
                        count += 1
                    }
                }
            }
        }

        return count
    }

    struct Hailstone {
        let position: SIMD3<Double>
        let velocity: SIMD3<Double>
    }

    private func makeHailstones() -> [Hailstone] {
        let captureNumber = Capture {
            Optionally { "-" }
            OneOrMore(.digit)
        }
        let regex = Regex {
            captureNumber; ","; OneOrMore(.whitespace); captureNumber; ","; OneOrMore(.whitespace); captureNumber
            OneOrMore(.whitespace); "@"; OneOrMore(.whitespace)
            captureNumber; ","; OneOrMore(.whitespace); captureNumber; ","; OneOrMore(.whitespace); captureNumber
        }

        return input.lines().compactMap { line in
            guard let match = line.matches(of: regex).first else {
                return nil
            }
            let (_, x, y, z, vx, vy, vz) =  match.output
            return Hailstone(position: SIMD3(Double(x)!, Double(y)!, Double(z)!),
                             velocity: SIMD3(Double(vx)!, Double(vy)!, Double(vz)!))
        }
    }

    // Finding where two lines cross can be done by calculating their cross product
    // https://www.hackingwithswift.com/example-code/core-graphics/how-to-calculate-the-point-where-two-lines-intersect
    func linesCross(start1: SIMD2<Double>, end1: SIMD2<Double>, start2: SIMD2<Double>, end2: SIMD2<Double>) -> (x: Double, y: Double)? {
        // calculate the differences between the start and end X/Y positions for each of our points
        let delta1x = end1.x - start1.x
        let delta1y = end1.y - start1.y
        let delta2x = end2.x - start2.x
        let delta2y = end2.y - start2.y

        // create a 2D matrix from our vectors and calculate the determinant
        let determinant = delta1x * delta2y - delta2x * delta1y

        if abs(determinant) < 0.0001 {
            // if the determinant is effectively zero then the lines are parallel/colinear
            return nil
        }

        // if the coefficients both lie between 0 and 1 then we have an intersection
        let ab = ((start1.y - start2.y) * delta2x - (start1.x - start2.x) * delta2y) / determinant

        if ab > 0 && ab < 1 {
            let cd = ((start1.y - start2.y) * delta1x - (start1.x - start2.x) * delta1y) / determinant

            if cd > 0 && cd < 1 {
                // lines cross – figure out exactly where and return it
                let intersectX = start1.x + ab * delta1x
                let intersectY = start1.y + ab * delta1y
                return (intersectX, intersectY)
            }
        }

        // lines don't cross
        return nil
    }
}
