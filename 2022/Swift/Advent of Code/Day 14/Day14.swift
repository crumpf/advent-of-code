//
//  Day14.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/14/22.
//

import Foundation
import RegexBuilder

class Day14: Day {
    func part1() -> String {
        "\(amountOfSandThatComesToRestBeforeFlowingIntoTheAbyss())"
    }
    
    func part2() -> String {
        "Not Implemented"
    }
    
    private func amountOfSandThatComesToRestBeforeFlowingIntoTheAbyss() -> Int {
        var cave = CaveMap(scanInput: input)
        cave.display()
        let count = cave.fillWithSand()
        cave.display()
        return count
    }
    
    typealias Boundaries = (min: SIMD2<Int>, max: SIMD2<Int>)
    
    struct CaveMap {
        private(set) var grid: [[Character]] = []
        private(set) var boundaries: Boundaries = (SIMD2.zero, SIMD2.zero)
        
        init(scanInput: String) {
            boundaries = findMapBoundaries(inScanInput: scanInput)
            grid = Array(
                repeating: Array(repeating: ".", count: 1 + (boundaries.max.x - boundaries.min.x)),
                count: boundaries.max.y + 1
            )
            
            for line in scanInput.lines() {
                let points = line.matches(of: pointsRegex).compactMap {
                    let (_, x, y) = $0.output
                    return SIMD2(Int(x)!, Int(y)!)
                }
                for line in zip(points, points.dropFirst()) {
                    if line.0.x == line.1.x {
                        for y in min(line.0.y, line.1.y)...max(line.0.y, line.1.y) {
                            grid[y][line.0.x - boundaries.min.x] = "#"
                        }
                    } else if line.0.y == line.1.y {
                        for x in min(line.0.x, line.1.x)...max(line.0.x, line.1.x) {
                            grid[line.0.y][x - boundaries.min.x] = "#"
                        }
                    }
                }
            }
        }
        
        subscript(index: SIMD2<Int>) -> Character {
            get {
                grid[index.y][index.x - boundaries.min.x]
            }
            set {
                grid[index.y][index.x - boundaries.min.x] = newValue
            }
        }
        
        func contains(index: SIMD2<Int>) -> Bool {
            grid.indices.contains(index.y) && grid[index.y].indices.contains(index.x - boundaries.min.x)
        }
        
        mutating func fillWithSand() -> Int {
            var count = 0
            while addSandUnit() {
                count += 1
            }
            return count
        }
        
        private mutating func addSandUnit() -> Bool {
            var sand = SIMD2(x: 500, y: -1)
            while let next = nextSandLocation(from: sand) {
                if !contains(index: next) {
                    // next location not on the map, falls into the abyss
                    return false
                }
                sand = next
            }
            if contains(index: sand) {
                self[sand] = "o"
            }
            return contains(index: sand)
        }
        
        private func nextSandLocation(from sand: SIMD2<Int>) -> SIMD2<Int>? {
            let down = sand &+ SIMD2(0, 1)
            let downAndLeft = sand &+ SIMD2(-1, 1)
            let downAndRight = sand &+ SIMD2(1, 1)
            if !contains(index: down) || self[down] == "." {
                return down
            }
            if !contains(index: downAndLeft) || self[downAndLeft] == "." {
                return downAndLeft
            }
            if !contains(index: downAndRight) || self[downAndRight] == "." {
                return downAndRight
            }
            return nil
        }
        
        private let pointsRegex = Regex {
            Capture {
                OneOrMore(.digit)
            }
            ","
            Capture {
                OneOrMore(.digit)
            }
        }
        
        private func findMapBoundaries(inScanInput scan: String) -> Boundaries {
            scan.matches(of: pointsRegex)
                .reduce(into: (min: SIMD2<Int>(Int.max, Int.max), max: SIMD2<Int>(Int.min, Int.min))) {
                    let (_, x, y) = $1.output
                    if let xInt = Int(x), let yInt = Int(y) {
                        $0.min.x = min($0.min.x, xInt)
                        $0.min.y = min($0.min.y, yInt)
                        $0.max.x = max($0.max.x, xInt)
                        $0.max.y = max($0.max.y, yInt)
                    }
                }
        }
        
        func display() {
            for row in grid {
                print(String(row))
            }
        }
    }
    
}
