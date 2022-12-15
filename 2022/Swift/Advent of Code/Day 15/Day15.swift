//
//  Day15.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/14/22.
//

import Foundation
import RegexBuilder

class Day15: Day {
    func part1() -> String {
        "\(numberOfPositionsThatCannotContainABeacon(inRow: 2_000_000))"
    }
    
    func part2() -> String {
        "Not Implemented"
    }
    
    func numberOfPositionsThatCannotContainABeacon(inRow row: Int) -> Int {
        let boundaries = findMapBoundaries()
        var count = 0
        for x in (boundaries.min.x - 500000)...(boundaries.max.x + 500000) {
            let vector = SIMD2(x, row)
            for (sensor, beacon) in closestBeacons {
                if vector == beacon {
                    continue
                }
                if vector.manhattanDistance(to: sensor) <= beacon.manhattanDistance(to: sensor) {
                    count += 1
                    break
                }
            }
        }
        return count
    }
    
    // key=sensor position, value=closest beacon position
    private lazy var closestBeacons: [SIMD2<Int>: SIMD2<Int>] = {
        let numberCapture = Capture {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        }
        let regex = Regex {
            "Sensor at x="
            numberCapture
            ", y="
            numberCapture
            ": closest beacon is at x="
            numberCapture
            ", y="
            numberCapture
        }
        var closestBeacons: [SIMD2<Int>: SIMD2<Int>] = [:]
        input.enumerateLines { line, stop in
            for match in line.matches(of: regex).enumerated() {
                let (_, sensorX, sensorY, beaconX, beaconY) = match.element.output
                closestBeacons[SIMD2(Int(sensorX)!, Int(sensorY)!)] = SIMD2(Int(beaconX)!, Int(beaconY)!)
            }
        }
        return closestBeacons
    }()
    
    typealias Boundaries = (min: SIMD2<Int>, max: SIMD2<Int>)

    private func findMapBoundaries() -> Boundaries {
        closestBeacons.reduce(into: (min: SIMD2<Int>(Int.max, Int.max), max: SIMD2<Int>(Int.min, Int.min))) {
            $0.min.x = min($0.min.x, min($1.key.x, $1.value.x))
            $0.min.y = min($0.min.y, min($1.key.y, $1.value.y))
            $0.max.x = max($0.max.x, max($1.key.x, $1.value.x))
            $0.max.y = max($0.max.y, max($1.key.y, $1.value.y))
        }
    }
}

extension SIMD2 where Scalar == Int {
    func manhattanDistance(to vector: Self) -> Scalar {
        let delta = self &- vector
        return abs(delta.x) + abs(delta.y)
    }
}
