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
        let dims = block.grid.dimensions()
        let leastHeat = block.leastHeat(from: SIMD2.zero, to: SIMD2(dims.x-1, dims.y-1))
        return "\(leastHeat)"
    }
    
    func part2() -> String {
        "Not Implemented"
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

    init(input: String) {
        grid = input.lines().map { s in
            s.map { c in
                Int(String(c))!
            }
        }
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
        let gridNeighbors = grid.neighbors(to: vertex.point)
        return gridNeighbors.map { point in
            let headingToNeighbor = point &- vertex.point
            return Node(point: point, heading: headingToNeighbor,
                        movesAlongHeading: headingToNeighbor == vertex.heading ? vertex.movesAlongHeading + 1 : 1)
        }
        .filter { $0.movesAlongHeading <= 3 && $0.point != vertex.point &- vertex.heading}
    }

    func leastHeat(from: SIMD2<Int>, to: SIMD2<Int>) -> Int {
        let path = DijkstraSearch.findPath(
            from: Node(point: SIMD2.zero, heading: SIMD2.zero, movesAlongHeading: 0),
            isDestination: { vertex in
                vertex.point == to
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
