//
//  Day22.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/22/23.
//
//  --- Day 22: Sand Slabs ---

import Foundation
import RegexBuilder

class Day22: Day {
    func part1() -> String {
        let snapshot = snapshot()
        let settled = settleBricks(snapshot)
        var count = 0
        for i in settled.indices {
            var tmp = settled
            tmp.remove(at: i)
            if !willAnySettle(tmp) { count += 1 }
        }
        return "\(count)"
    }
    
    func part2() -> String {
        "Not Implemented"
    }

    func snapshot() -> [Brick] {
        input.lines().compactMap(Brick.init(string:))
    }

    func settleBricks(_ bricks: [Brick]) -> [Brick] {
        var settled: [Brick] = []
        for brick in bricks.sorted(by: { $0.start.z < $1.start.z }) {
            if let sitsOn = settled.last(where: { b in
                brick.start.x <= b.end.x && brick.end.x >= b.start.x &&
                brick.start.y <= b.end.y && brick.end.y >= b.start.y
            }) {
                settled.append(brick.translated(by: SIMD3(0, 0, 1 + sitsOn.end.z - brick.start.z)))
            } else {
                settled.append(brick.translated(by: SIMD3(0, 0, 1 - brick.start.z)))
            }
        }
        return settled
    }

    func willAnySettle(_ bricks: [Brick]) -> Bool {
        var settled: [Brick] = []
        for brick in bricks.sorted(by: { $0.start.z < $1.start.z }) {
            var nextZ = 0
            if let sitsOn = settled.last(where: { b in
                brick.start.x <= b.end.x && brick.end.x >= b.start.x &&
                brick.start.y <= b.end.y && brick.end.y >= b.start.y
            }) {
                nextZ = 1 + sitsOn.end.z - brick.start.z
            } else {
                nextZ = 1 - brick.start.z
            }
            if nextZ != 0 {
                return true
            } else {
                settled.append(brick.translated(by: SIMD3(0, 0, nextZ)))
            }
        }
        return false
    }

    struct Brick {
        let start, end: SIMD3<Int>

        init?(string: String) {
            let captureInt = Capture {
                Optionally { "-" }
                OneOrMore(.digit)
            }
            let connectionRegex = Regex {
                captureInt; ","; captureInt; ","; captureInt
                "~"
                captureInt; ","; captureInt; ","; captureInt
            }
            guard let match = string.matches(of: connectionRegex).first else {
                return nil
            }

            let (_, x1, y1, z1, x2, y2, z2) =  match.output
            self.init(start: SIMD3(Int(x1)!, Int(y1)!, Int(z1)!), end: SIMD3(Int(x2)!, Int(y2)!, Int(z2)!))
        }

        init(start: SIMD3<Int>, end: SIMD3<Int>) {
            self.start = start
            self.end = end
        }

        func translated(by: SIMD3<Int>) -> Brick {
            Brick(start: start &+ by, end: end &+ by)
        }
    }

}
