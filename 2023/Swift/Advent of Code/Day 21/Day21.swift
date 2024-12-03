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
        "Not Implemented"
    }

}

fileprivate typealias Grid = [[Character]]

fileprivate extension Grid {
    func dimensions() -> (x: Int, y: Int) { (x: self[0].count, y: count) }

    func char(at vertex: SIMD2<Int>) -> Character { self[vertex.y][vertex.x] }

    func contains(_ vertex: SIMD2<Int>) -> Bool {
        vertex.y >= 0 && vertex.y < count && vertex.x >= 0 && vertex.x < self[0].count
    }

    func neighbors(to vertex: SIMD2<Int>) -> [SIMD2<Int>] {
        [Directions.east, Directions.south, Directions.west, Directions.north]
            .map { vertex &+ $0 }
            .filter(contains(_:))
    }

    struct Directions {
        static var north = SIMD2(0, -1), west = SIMD2(-1, 0), south = SIMD2(0, 1), east = SIMD2(1, 0)
    }
}

fileprivate struct Garden: Pathfinding {
    let grid: Grid
    let start: SIMD2<Int>

    init(input: String) {
        grid = input.lines().map { Array($0) }
        let dims = grid.dimensions()
        let i = input.distance(from: input.startIndex, to: input.firstIndex(of: "S")!)
        start = SIMD2(i%(dims.x+1), i/(dims.x+1))
    }

    struct Node: Hashable {
        let point: SIMD2<Int>
        let steps: Int
    }

    func numberOfPlotsReachableAfter(steps: Int) -> Int {
        var reachable: Set<SIMD2<Int>> = []
        let _ = BreadthFirstSearch.findPath(
            from: Node(point: start, steps: 0),
            isDestination: { vertex in
                guard vertex.steps < steps + 1 else { return true }
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
        grid.neighbors(to: vertex.point)
            .filter { grid.char(at: $0) != "#" }
            .map { Node(point: $0, steps: vertex.steps + 1) }
    }
}
