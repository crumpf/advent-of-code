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
        let digPlan = CorrectedDigPlan(input: input)
        let vertices = digPlan.perimeterVertices()
        let area = digPlan.area(withinPerimeter: vertices)
        let perim = zip(vertices, vertices.dropFirst()).reduce(0) { partialResult, pts in
            let diff = pts.1 &- pts.0
            return partialResult + abs(diff.x) + abs(diff.y)
        }
        //TODO: Not sure why I have to fudge the answer by 1 to get the answer. I need to prove this to myself.
        return "\(area + (perim / 2) + 1)"
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

        static func makeDigDirection(digit: Character) -> DigDirection? {
            switch digit {
            case "0": return .right
            case "1": return .down
            case "2": return .left
            case "3": return .up
            default: return nil
            }
        }
    }

    struct Command {
        let direction: DigDirection
        let distance: Int
        let color: String
    }

    struct DigPlan {
        let commands: [Command]

        init(input: String) {
            commands = input.lines().map({ line in
                let comps = line.components(separatedBy: .whitespaces)
                return Command(direction: DigDirection(rawValue: comps[0])!, distance: Int(comps[1])!, color: comps[2])
            })
        }

        func digPerimeter() -> Set<Point> {
            var current = Point.zero
            var perimeter = Set<Point>([current])
            for command in commands {
                (1...command.distance).forEach { dist in
                    let digPoint = current &+ (command.direction.vector &* dist)
                    perimeter.insert(digPoint)
                }
                current = current &+ (command.direction.vector &* command.distance)
            }
            return perimeter
        }

        func interior(ofPerimeter perimeter: Set<Point>) -> Set<Point> {
            let sortedByX = perimeter.sorted { $0.x < $1.x }
            // flood-fill starting from the point to the right of the leftmost point in our perimeter. this should be an interior point.
            let leftmost = sortedByX.first(where:{!perimeter.contains($0 &+ DigDirection.right.vector)})!
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
                adjs.forEach { adjacent in
                    if !(minX...maxX).contains(adjacent.x) || !(minY...maxY).contains(adjacent.y) {
                        abort()
                    }
                    frontier.push(adjacent)
                }
            }
            return interior
        }
    }

    struct CorrectedDigPlan {
        let commands: [Command]

        init(input: String) {
            commands = input.lines().map({ line in
                let comps = line.components(separatedBy: .whitespaces)
                let dist = Int(comps[2][2...6], radix: 16)!
                let dir = DigDirection.makeDigDirection(digit: comps[2][7])!
                return Command(direction: dir, distance: dist, color: "\(comps[0]) \(comps[1])")
            })
        }

        func perimeterVertices() -> [Point] {
            var current = Point.zero
            var vertices = [current]
            for command in commands {
                current = current &+ (command.direction.vector &* command.distance)
                vertices.append(current)
            }
            return vertices
        }

        func area(withinPerimeter perim: [Point]) -> Int {
            // shoelace formula: https://en.wikipedia.org/wiki/Shoelace_formula
            var area = 0
            for pair in zip(perim, perim.dropFirst()) {
                area += pair.0.x * pair.1.y
                area -= pair.0.y * pair.1.x
            }
            return area / 2
        }
    }
}
