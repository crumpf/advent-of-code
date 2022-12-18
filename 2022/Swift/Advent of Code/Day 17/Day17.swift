//
//  Day17.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/17/22.
//

import Foundation

class Day17: Day {
    func part1() -> String {
        "\(heightOfTower(afterNumberOfStoppedRocks: 2022))"
    }
    
    func part2() -> String {
        "\(heightOfTower(afterAbsurdNumberOfStoppedRocks: 1000000000000))"
    }
    
    typealias Point = SIMD2<Int>
    
    private func heightOfTower(afterNumberOfStoppedRocks count: Int) -> Int {
        let chamber = Chamber(jetPattern: input.trimmingCharacters(in: .whitespacesAndNewlines))
        for _ in 1...count {
            chamber.dropRock()
        }
        return chamber.towerHeight
    }
    
    private func heightOfTower(afterAbsurdNumberOfStoppedRocks count: Int) -> Int {
        let chamber = Chamber(jetPattern: input.trimmingCharacters(in: .whitespacesAndNewlines))
        // this solution is pretty hacky. I found some of thse magic numbers with a bit of trial and error
        // run enough drops to hopefully contain cycles
        for _ in 1...4000 {
            chamber.dropRock()
        }
        // see if we can find a cycle
        // pick an arbitrary point, i, to start at
        let i = 200
        var size = 2
        while chamber.rockResults[i..<(i+size)] != chamber.rockResults[(i+size)..<(i + 2*size)] {
            size += 1
        }
        let heightBeforeCycle = chamber.heights[i - 1]
        let heightDuringCycle = chamber.heights[i + size - 1] - heightBeforeCycle
        let result = ((count-i)/size)*heightDuringCycle + chamber.heights[i + (count-i)%size - 1]
        return result
    }
    
    class Chamber {
        private(set) var settledPoints = Set<Point>()
        private(set) var towerHeight = 0
        private let rockShapes = [
            // ####
            [Point(0,0), Point(1,0), Point(2,0), Point(3,0)],
            // .#.
            // ###
            // .#.
            [Point(0,1), Point(1,0), Point(1,1), Point(1,2), Point(2,1)],
            // ..#
            // ..#
            // ###
            [Point(0,0), Point(1,0), Point(2,0), Point(2,1), Point(2,2)],
            // #
            // #
            // #
            // #
            [Point(0,0), Point(0,1), Point(0,2), Point(0,3)],
            // ##
            // ##
            [Point(0,0), Point(1,0), Point(0,1), Point(1,1)]
        ]
        private var rockShapeIndex = 0
        private let jetPattern: String
        private var jetIndex = 0
        private(set) var rockResults = [RockResult]()
        private(set) var heights = [Int]()
        
        struct RockResult: Equatable {
            let rocktype: Int
            let stopDelta: Point
        }
        
        init(jetPattern: String) {
            self.jetPattern = jetPattern
        }

        func dropRock() {
            var origin = Point(2, towerHeight + 3)
            var rockPoints = rockShapes[rockShapeIndex].map { origin &+ $0 }
            while true {
                // deal with the horizontal blowing of jets
                let delta = jetPattern[jetIndex] == "<" ? Point(-1,0) : Point(1,0)
                jetIndex = (jetIndex + 1) % jetPattern.count
                let jettedOrigin = origin &+ delta
                let jettedPoints = rockShapes[rockShapeIndex].map { jettedOrigin &+ $0 }
                if check(points: jettedPoints) {
                    origin = jettedOrigin
                    rockPoints = jettedPoints
                }
                
                // deal with gravity
                let gravityOrigin = origin &+ Point(0,-1)
                let gravityPoints = rockShapes[rockShapeIndex].map { gravityOrigin &+ $0 }
                if check(points: gravityPoints) {
                    origin = gravityOrigin
                    rockPoints = gravityPoints
                } else {
                    rockResults.append(RockResult(rocktype: rockShapeIndex,
                                                  stopDelta: Point(2, towerHeight + 3) &- origin))
                    settledPoints = settledPoints.union(rockPoints)
                    rockShapeIndex = (rockShapeIndex + 1) % rockShapes.count
                    towerHeight = max(towerHeight, 1 + rockPoints.max { $0.y < $1.y }!.y)
                    heights.append(towerHeight)
                    return
                }
            }
        }
        
        // see if points are out of bounds or overlapping settled rocks, true if all is well
        func check(points: [Point]) -> Bool {
            let inBounds = points.reduce(true) { $0 && $1.x >= 0 && $1.x < 7 && $1.y >= 0 }
            return inBounds && settledPoints.intersection(points).count == 0
        }
    }
    
}
