//
//  Day17.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/17/23.
//

import Foundation

class Day17: Day {
    func part1() -> String {
        let block = Block(input: input)
        let leastHeat = block.leastHeat()
        return "\(leastHeat)"
    }
    
    func part2() -> String {
        let block = Block(input: input, isUltra: true)
        let leastHeat = block.leastHeat()
        return "\(leastHeat)"
    }
}

fileprivate typealias Grid = [[Int]]

fileprivate extension Grid {
    func dimensions() -> (x: Int, y: Int) { (x: self[0].count, y: count) }

    func value(at vertex: SIMD2<Int>) -> Int { self[vertex.y][vertex.x] }

    func contains(_ vertex: SIMD2<Int>) -> Bool {
        vertex.y >= 0 && vertex.y < count && vertex.x >= 0 && vertex.x < self[0].count
    }

    func neighbors(to vertex: SIMD2<Int>) -> [SIMD2<Int>] {
        [Directions.east, Directions.south, Directions.west, Directions.north]
            .map { vertex &+ $0 }
            .filter(contains(_:))
    }

    struct Directions {
        static var north = SIMD2(0, -1)
        static var west = SIMD2(-1, 0)
        static var south = SIMD2(0, 1)
        static var east = SIMD2(1, 0)
    }
}

fileprivate struct Block: WeightedPathfinding {
    let grid: Grid
    let isUltra: Bool

    private let start: SIMD2<Int>
    private let goal: SIMD2<Int>

    init(input: String, isUltra: Bool = false) {
        grid = input.lines().map { s in
            s.map { c in
                Int(String(c))!
            }
        }
        self.isUltra = isUltra

        let dims = grid.dimensions()
        start = SIMD2.zero
        goal = SIMD2(dims.x-1, dims.y-1)
    }

    struct Node: Hashable {
        let point: SIMD2<Int>
        let heading: SIMD2<Int>
        let movesAlongHeading: Int
    }

    typealias Cost = Int
    typealias Vertex = Node

    func cost(from: Vertex, to: Vertex) -> Int {
        guard from != to else { return 0 }
        return grid.value(at: to.point)
    }

    func neighbors(for vertex: Vertex) -> [Vertex] {
        if !isUltra {
            let gridNeighbors = grid.neighbors(to: vertex.point)
            return gridNeighbors.map { point in
                let headingToNeighbor = point &- vertex.point
                return Node(point: point, heading: headingToNeighbor,
                            movesAlongHeading: headingToNeighbor == vertex.heading ? vertex.movesAlongHeading + 1 : 1)
            }
            .filter { $0.movesAlongHeading <= 3 && $0.point != vertex.point &- vertex.heading}
        } else {
            guard !(1..<4).contains(vertex.movesAlongHeading) else {
                let nextNode = Node(point: vertex.point &+ vertex.heading, heading: vertex.heading, movesAlongHeading: vertex.movesAlongHeading + 1)
                return grid.contains(nextNode.point) ? [nextNode] : []
            }

            let gridNeighbors = grid.neighbors(to: vertex.point)
            return gridNeighbors.map { point in
                let headingToNeighbor = point &- vertex.point
                let movesAlongHeading = headingToNeighbor == vertex.heading ? vertex.movesAlongHeading + 1 : 1
                return Node(point: point, heading: headingToNeighbor, movesAlongHeading: movesAlongHeading)
            }
            .filter {
                if $0.point == goal && $0.movesAlongHeading < 4 {
                    return false
                }
                return $0.movesAlongHeading <= 10 && $0.point != vertex.point &- vertex.heading
            }
        }
    }

    func leastHeat() -> Int {
        let path = DijkstraSearch.findPath(
            from: Node(point: start, heading: SIMD2.zero, movesAlongHeading: 0),
            isDestination: { vertex in
                vertex.point == goal
            }, in: self)

        printPathFromNode(path)

        return path?.cost ?? -1
    }

    private func printPathFromNode(_ pathNode: WeightedPathNode<Block.Vertex, Block.Cost>?) {
        var current = pathNode
        while let n = current {
            print("\(n.vertex) : \(n.cost)")
            current = current?.predecessor as? WeightedPathNode
        }
    }
}
