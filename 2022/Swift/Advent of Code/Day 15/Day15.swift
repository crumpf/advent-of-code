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
        let boundaries = findMapBoundaries()
        var count = 0
        // this is hacky, just expanding the search area an arbitrary amount hoping to capture all the available positions
        for x in (boundaries.min.x - 500_000)...(boundaries.max.x + 500_000) {
            let vector = SIMD2(x, row)
            for (sensor, beacon) in closestBeacons {
                // check if there's already a beacon here
                if vector == beacon {
                    continue
                }
                // check if the vector being looked at is within sight of of the sensor, meaning its
                // distance from the senson is <= the beacon's distance to the sensor
                if vector.manhattanDistance(to: sensor) <= beacon.manhattanDistance(to: sensor) {
                    count += 1
                    break
                }
            }
        }
        return count
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
    
    func tuningFrequency() -> Int {
        return 4_000_000 * x + y
    }
}
