//
//  Day21.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/21/23.
//
//  --- Day 21: Step Counter ---

import Foundation

class Day21: Day {
    func part1() -> String {
        let garden = Garden(input: input)
        return "\(garden.numberOfPlotsReachableAfter(steps: 64))"
    }
    
    func part2() -> String {
        let garden = Garden(input: input, infinite: true)
        return "\(garden.numberOfPlotsReachableAfter(steps: 5000))"
    }
}

fileprivate typealias Grid = [[Character]]

fileprivate extension Grid {
    func dimensions() -> (x: Int, y: Int) { (x: self[0].count, y: count) }

    func char(at vertex: SIMD2<Int>, infinite: Bool = false) -> Character {
        if !infinite {
            return self[vertex.y][vertex.x]
        } else {
            let pt = infinitePointToGridPoint(vertex: vertex)
            return self[pt.y][pt.x]
        }
    }

    func contains(_ vertex: SIMD2<Int>) -> Bool {
        vertex.y >= 0 && vertex.y < count && vertex.x >= 0 && vertex.x < self[0].count
    }

    func infinitePointToGridPoint(vertex: SIMD2<Int>) -> SIMD2<Int> {
        let dims = dimensions()
        return SIMD2<Int>(
            ((vertex.x % dims.x) + dims.x) % dims.x,
            ((vertex.y % dims.y) + dims.y) % dims.y
        )
    }

    func neighbors(to vertex: SIMD2<Int>) -> [SIMD2<Int>] {
        [Directions.east, Directions.south, Directions.west, Directions.north]
            .map { vertex &+ $0 }
            .filter(contains(_:))
    }

    func unrestrainedNeighbors(to vertex: SIMD2<Int>) -> [SIMD2<Int>] {
        [Directions.east, Directions.south, Directions.west, Directions.north].map { vertex &+ $0 }
    }

    struct Directions {
        static var north = SIMD2(0, -1), west = SIMD2(-1, 0), south = SIMD2(0, 1), east = SIMD2(1, 0)
    }
}

fileprivate struct Garden: Pathfinding {
    let grid: Grid
    let start: SIMD2<Int>
    let isInfinite: Bool

    init(input: String, infinite: Bool = false) {
        isInfinite = infinite
        grid = input.lines().map { Array($0) }
        let dims = grid.dimensions()
        let i = input.distance(from: input.startIndex, to: input.firstIndex(of: "S")!)
        start = SIMD2(i%(dims.x+1), i/(dims.x+1))
    }

    struct Node: Hashable {
        let point: SIMD2<Int>
        let steps: Int
    }

    // TODO: this works ok for smaller steps, but as the steps grow the processing time
    //       is one of those deals that starts to spiral exponentionally, so I need a more clever solution.
    func numberOfPlotsReachableAfter(steps: Int) -> Int {
        var reachable: Set<SIMD2<Int>> = []
        let _ = BreadthFirstSearch.findPath(
            from: Node(point: start, steps: 0),
            isDestination: { vertex in
                guard vertex.steps < steps + 1 else { return true }

                let pt = grid.infinitePointToGridPoint(vertex: vertex.point)
                if pt == start && vertex.point != start {
                    print(vertex)
                }

                if vertex.steps == steps {
                    reachable.insert(vertex.point)
                }
                return false
            }, in: self)
        return reachable.count
    }

    //MARK: Pathfinding

    typealias Vertex = Node

    func neighbors(for vertex: Vertex) -> [Vertex] {
        if !isInfinite {
            grid.neighbors(to: vertex.point)
                .filter { grid.char(at: $0) != "#" }
                .map { Node(point: $0, steps: vertex.steps + 1) }
        } else {
            grid.unrestrainedNeighbors(to: vertex.point)
                .filter { grid.char(at: $0, infinite: true) != "#" }
                .map { Node(point: $0, steps: vertex.steps + 1) }
        }
    }
}
