//
//  Day09.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/09/2022.
//

import Foundation

class Day09: Day {
    
    func part1() -> String {
        "\(numberOfPositionsVisitedByRopeTailForMotions(motions, knots: 2))"
    }
    
    func part2() -> String {
        "\(numberOfPositionsVisitedByRopeTailForMotions(motions, knots: 10))"
    }
    
    enum Direction: String {
        case up = "U", down = "D", left = "L", right = "R"
    }
    
    struct Motion {
        let direction: Direction
        let steps: Int
    }
    
    private lazy var motions: [Motion] = input.lines().compactMap {
        let comps = $0.components(separatedBy: .whitespaces)
        guard comps.count == 2, let dir = Direction(rawValue: comps[0]), let steps = Int(comps[1]) else {
            return nil
        }
        return Motion(direction: dir, steps: steps)
    }
    
    private func numberOfPositionsVisitedByRopeTailForMotions(_ motions: [Motion], knots: Int) -> Int {
        guard knots > 1 else { return 0 }
        var rope = Array(repeating: SIMD2<Int>.zero, count: knots)
        var tailVisits = Set([rope.last!])
        for motion in motions {
            for _ in 0..<motion.steps {
                rope[0].step(motion.direction)
                for i in 1..<rope.count {
                    rope[i].follow(rope[i-1])
                }
                tailVisits.insert(rope.last!)
            }
        }
        return tailVisits.count
    }
    
}

extension SIMD2 where Scalar == Int {
    mutating func step(_ direction: Day09.Direction) {
        switch direction {
        case .up:    y += 1
        case .down:  y -= 1
        case .left:  x -= 1
        case .right: x += 1
        }
    }
    
    mutating func follow(_ vector: SIMD2<Int>) {
        switch vector &- self {
        case let delta where abs(delta.x) > 1:
            x += delta.x > 0 ? 1 : -1
            if abs(delta.y) > 0 {
                y += delta.y > 0 ? 1 : -1
            }
        case let delta where abs(delta.y) > 1:
            y += delta.y > 0 ? 1 : -1
            if abs(delta.x) > 0 {
                x += delta.x > 0 ? 1 : -1
            }
        default: break
        }
    }
}
