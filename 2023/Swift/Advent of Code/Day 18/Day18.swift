//
//  DayX.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on MM/DD/YY.
//

import Foundation

class Day18: Day {
    func part1() -> String {
        let digPlan = DigPlan(input: input)
        let perimeter = digPlan.digPerimeter()
        let interior = digPlan.interior(ofPerimeter: perimeter)
        return "\(perimeter.count + interior.count)"
    }
    
    func part2() -> String {
        "Not Implemented"
    }


    typealias Point = SIMD2<Int>
    typealias Vector = SIMD2<Int>

    enum DigDirection: String, CaseIterable {
        case up = "U", down = "D", left = "L", right = "R"

        var vector: Vector {
            switch self {
            case .up: return Vector(0,-1)
            case .down: return Vector(0,1)
            case .left: return Vector(-1,0)
            case .right: return Vector(1,0)
            }
        }
    }

    struct Command {
        let direction: DigDirection
        let meters: Int
        let color: String
    }

    struct DigPlan {
        let commands: [Command]

        init(input: String) {
            commands = input.lines().map({ line in
                let comps = line.components(separatedBy: .whitespaces)
                return Command(direction: DigDirection(rawValue: comps[0])!, meters: Int(comps[1])!, color: comps[2])
            })
        }

        func digPerimeter() -> Set<Point> {
            var current = Point.zero
            var perimeter = Set<Point>([current])
            for command in commands {
                (1...command.meters).forEach { dist in
                    let digPoint = current &+ (command.direction.vector &* dist)
                    perimeter.insert(digPoint)
                }
                current = current &+ (command.direction.vector &* command.meters)
            }
            return perimeter
        }

        func interior(ofPerimeter perimeter: Set<Point>) -> Set<Point> {
            let sortedByX = perimeter.sorted { $0.x < $1.x }
            let leftmost = sortedByX.first! // // flood-fill starting from the point to the right of the leftmost point in our perimeter. this should be an interior point.
            let minX = leftmost.x, maxX = sortedByX.last!.x
            let minY = perimeter.min { $0.y < $1.y }!.y, maxY = perimeter.max { $0.y < $1.y }!.y
            var interior = Set<Point>()
            var frontier = Stack<Point>()
            frontier.push(Point(leftmost.x + 1, leftmost.y))
            while let pt = frontier.pop() {
                interior.insert(pt)
                let adjs = DigDirection.allCases
                    .map { pt &+ $0.vector }
                    .filter { !perimeter.contains($0) && !interior.contains($0)  }
                adjs.forEach {
                    if !(minX...maxX).contains($0.x) || !(minY...maxY).contains($0.y) {
                        abort()
                    }
                    frontier.push($0)
                }
            }
            return interior
        }
    }
}
