//
//  Day24.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/24/22.
//

import Foundation

class Day24: Day {
    func part1() -> String {
        "\(fewestNumberOfMinutesToAvoidBlizzardsAndReachTheGoal())"
    }
    
    func part2() -> String {
        "\(fewestMinutesToReachGoalGoBackToStartThenReachGoalAgain())"
    }
    
    private func fewestNumberOfMinutesToAvoidBlizzardsAndReachTheGoal() -> Int {
        let valley = makeValley(from: input)
        let path = BreadthFirstSearch.findPath(
            from: valley.start,
            isDestination: { vertex in
                vertex.x == valley.end.x && vertex.y == valley.end.y
            },
            in: valley
        )
        return path?.vertex.z ?? -1
    }
    
    private func fewestMinutesToReachGoalGoBackToStartThenReachGoalAgain() -> Int {
        let valley = makeValley(from: input)
        let path1 = BreadthFirstSearch.findPath(
            from: valley.start,
            isDestination: { vertex in
                vertex.x == valley.end.x && vertex.y == valley.end.y
            },
            in: valley
        )
        let path2 = BreadthFirstSearch.findPath(
            from: path1!.vertex,
            isDestination: { vertex in
                vertex.x == valley.start.x && vertex.y == valley.start.y
            },
            in: valley
        )
        let path3 = BreadthFirstSearch.findPath(
            from: path2!.vertex,
            isDestination: { vertex in
                vertex.x == valley.end.x && vertex.y == valley.end.y
            },
            in: valley
        )
        return path3?.vertex.z ?? -1
    }
    
    typealias Point = SIMD2<Int>
    typealias PointTime = SIMD3<Int> // x, y location and z for time
    
    class Valley: Pathfinding {
        let width: Int
        let height: Int
        let start: PointTime
        let end: Point
        let upMovingBlizzards: Set<Point>
        let downMovingBlizzards: Set<Point>
        let leftMovingBlizzards: Set<Point>
        let rightMovingBlizzards: Set<Point>
        let ground: Set<Point>
        
        init(width: Int, height: Int, start: PointTime, end: Point, upMovingBlizzards: Set<Point>, downMovingBlizzards: Set<Point>, leftMovingBlizzards: Set<Point>, rightMovingBlizzards: Set<Point>, ground: Set<Point>) {
            self.width = width
            self.height = height
            self.start = start
            self.end = end
            self.upMovingBlizzards = upMovingBlizzards
            self.downMovingBlizzards = downMovingBlizzards
            self.leftMovingBlizzards = leftMovingBlizzards
            self.rightMovingBlizzards = rightMovingBlizzards
            self.ground = ground
        }
        
        private var openSpacesAtTime = [Int: Set<PointTime>]()
        
        func getOpenSpaces(atTime time: Int) -> Set<PointTime> {
            if let alreadyComputed = openSpacesAtTime[time] {
                return alreadyComputed
            }
            
            let up = upMovingBlizzards.map {
                var y = ($0.y - time) % (height - 2)
                if y <= 0 { y = height - 2 + y }
                return PointTime($0.x, y, time)
            }
            let down = downMovingBlizzards.map {
                let y = 1 + (($0.y - 1 + time) % (height - 2))
                return PointTime($0.x, y, time)
            }
            let left = leftMovingBlizzards.map {
                var x = ($0.x - time) % (width - 2)
                if x <= 0 { x = width - 2 + x }
                return PointTime(x, $0.y, time)
            }
            let right = rightMovingBlizzards.map {
                let x = 1 + (($0.x - 1 + time) % (width - 2))
                return PointTime(x, $0.y, time)
            }
            
            let open = Set(ground.map { PointTime($0, time) })
                .subtracting(up + down + left + right)
            openSpacesAtTime[time] = open
            return open
        }
        
        // MARK: Pathfinding
        typealias Vertex = PointTime
        
        func neighbors(for vertex: Vertex) -> [Vertex] {
            let future = vertex.z + 1
            let open = getOpenSpaces(atTime: future).intersection(vertex.futureAdjacents())
            return Array(open)
        }
    }
    
    private func makeValley(from input: String) -> Valley {
        var up = Set<Point>(), down = Set<Point>(), left = Set<Point>(), right = Set<Point>(), ground = Set<Point>()
        let lines = input.lines()
        let height = lines.count, width = lines[0].count
        var start: PointTime?, end: Point?
        for (x, c) in lines[0].enumerated() {
            if c == "." {
                ground.insert(Point(x, 0))
                start = PointTime(x, 0, 0)
                break
            }
        }
        for (x, c) in lines[height-1].enumerated() {
            if c == "." {
                ground.insert(Point(x, height-1))
                end = Point(x, height-1)
                break
            }
        }
        for y in 1..<(height - 1) {
            let line = lines[y]
            for x in 1..<(line.count - 1) {
                ground.insert(Point(x, y))
                switch line[x] {
                case "^": up.insert(Point(x, y))
                case "v": down.insert(Point(x, y))
                case "<": left.insert(Point(x, y))
                case ">": right.insert(Point(x, y))
                default: break
                }
            }
        }
        return Valley(width: width, height: height, start: start!, end: end!, upMovingBlizzards: up, downMovingBlizzards: down, leftMovingBlizzards: left, rightMovingBlizzards: right, ground: ground)
    }
}

private extension Day24.PointTime {
    func futureAdjacents() -> [Self] {
        [Self(0,0,1), Self(1,0,1), Self(0,1,1), Self(-1,0,1), Self(0,-1,1)]
            .map { $0 &+ self }
    }
}
