//
//  Day09.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/09/2022.
//

import Foundation

class Day09: Day {
    struct Motion {
        let direction: String
        let steps: Int
    }
    
    private lazy var motions: [Motion] = input.lines().compactMap {
        let comps = $0.components(separatedBy: .whitespaces)
        guard comps.count == 2, let steps = Int(comps[1]) else { return nil }
        return Motion(direction: comps[0], steps: steps)
    }
    
    func part1() -> String {
        "\(numberOfPositionsVisitedByRopeTailForMotions(motions))"
    }
    
    func part2() -> String {
        return "Not Implemented"
    }
    
    private func numberOfPositionsVisitedByRopeTailForMotions(_ motions: [Motion]) -> Int {
        var head = SIMD2<Int>.zero, tail = SIMD2<Int>.zero
        var visited: Set<SIMD2<Int>> = [tail]
        for motion in motions {
            for _ in 0..<motion.steps {
                switch motion.direction {
                case "U": head.y += 1
                case "D": head.y -= 1
                case "L": head.x -= 1
                case "R": head.x += 1
                default: break
                }
                switch head &- tail {
                case let delta where delta.x > 1:
                    tail = SIMD2(head.x - 1, head.y)
                case let delta where delta.x < -1:
                    tail = SIMD2(head.x + 1, head.y)
                case let delta where delta.y > 1:
                    tail = SIMD2(head.x, head.y - 1)
                case let delta where delta.y < -1:
                    tail = SIMD2(head.x, head.y + 1)
                default: break
                }
                visited.insert(tail)
            }
        }
        return visited.count
    }
    
}
