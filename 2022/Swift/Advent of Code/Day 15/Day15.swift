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
        "\(tuningFrequencyOfDistressBeaconHavingSearchBounds(lower: 0, upper: 4_000_000))"
    }
    
    func numberOfPositionsThatCannotContainABeacon(inRow row: Int) -> Int {
        let ranges = xRangesSeenBySensors(atYCoordinate: row)
        let beaconsInRow: Set<SIMD2<Int>> = Set(closestBeacons.compactMap { (sensor, beacon) in
            guard beacon.y == row else {
                return nil
            }
            return beacon
        })
        let beaconsWithinRanges = beaconsInRow.filter { beacon in
            for r in ranges where r.contains(beacon.x) {
                return true
            }
            return false
        }
        // sum the count of our ranges and subtract out the beacons that already occupy space within the ranges
        return ranges.reduce(0) { $0 + $1.count } - beaconsWithinRanges.count
    }
    
    func tuningFrequencyOfDistressBeaconHavingSearchBounds(lower: Int, upper: Int) -> Int {
        // The sensors can only see out to a single becon, and the distress beacon is be outside the
        // fields of view of all the beacons. So, this approach finds all the vertices that are one
        // step beyound the distance between each sensor and beacon and then evaluates all of those to
        // see if they're contained within the field of view of any other sensors. If we find one that
        // no sensors see, that's where the distress beacon must be.
        // This is pretty slow, and there's probably a way to reduce the search space, but
        // this is Advent of Code and let's keep it moving.
        let range = lower...upper
        let borders = closestBeacons.map { (sensor, beacon) in
            let radius = sensor.manhattanDistance(to: beacon)
            return sensor.borderVertices(havingManhattanDistance: radius + 1)
        }
        
        for vertices in borders {
            for vertex in vertices.filter({ range.contains($0.x) && range.contains($0.y)
            }) {
                var withinSensorsRange = false
                for (sensor, beacon) in closestBeacons {
                    if sensor.manhattanDistance(to: beacon) >= sensor.manhattanDistance(to: vertex) {
                        withinSensorsRange = true
                        break
                    }
                }
                if !withinSensorsRange {
                    return vertex.tuningFrequency()
                }
            }
        }
        return -1
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
    
    private func xRangesSeenBySensors(atYCoordinate y: Int) -> [ClosedRange<Int>] {
        closestBeacons.compactMap { (sensor, beacon) in
            let distance = sensor.manhattanDistance(to: beacon)
            return sensor.xRange(withinManhattanDistance: distance, atY: y)
        }
        .mergeOverlapping()
    }
    
}

extension SIMD2 where Scalar == Int {
    func manhattanDistance(to vector: Self) -> Scalar {
        let delta = self &- vector
        return abs(delta.x) + abs(delta.y)
    }
    
    func borderVertices(havingManhattanDistance distance: Int) -> Set<Self> {
        guard distance > 0 else {
            return distance == 0 ? [self] : []
        }
        var vectors = Set<Self>()
        for x in -distance...distance {
            let y = distance - abs(x)
            vectors.insert(self &+ SIMD2(x, y))
            if y > 0 {
                vectors.insert(self &+ SIMD2(x, -y))
            }
        }
        return vectors
    }
    
    func xRange(withinManhattanDistance distance: Int, atY: Int) -> ClosedRange<Int>? {
        let deltaY = abs(y - atY)
        let deltaX = distance - deltaY
        guard (0...distance).contains(deltaX) else {
            return nil
        }
        return (x - deltaX)...(x + deltaX)
    }
    
    func tuningFrequency() -> Int {
        return 4_000_000 * x + y
    }
}
