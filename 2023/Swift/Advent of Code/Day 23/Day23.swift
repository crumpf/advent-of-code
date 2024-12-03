//
//  DayX.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on MM/DD/YY.
//

import Foundation
import HeapModule

class Day23: Day {
    func part1() -> String {
        let map = Map(input: input)
        return "\(map.stepsInTheLongestHike())"
    }
    
    func part2() -> String {
        let map = Map(input: input)
        return "\(map.stepsInTheLongestHikeSlopsAsNormalPaths())"
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

fileprivate struct Map: WeightedPathfinding {
    let grid: Grid
    let dimensions: (x: Int, y: Int)
    let start: SIMD2<Int>
    let end: SIMD2<Int>

    init(input: String) {
        grid = input.lines().map { Array($0) }
        dimensions = grid.dimensions()
        let si = input.distance(from: input.startIndex, to: input.firstIndex(of: ".")!)
        start = SIMD2(si%(dimensions.x+1), si/(dimensions.x+1))
        let ei = input.distance(from: input.startIndex, to: input.lastIndex(of: ".")!)
        end = SIMD2(ei%(dimensions.x+1), ei/(dimensions.x+1))
    }

    func stepsInTheLongestHike() -> Int {
        var longest = 0
        let _ = DijkstraSearch.findPath(
            from: Node(v: start, steps: 0),
            neighbors: { path in
                let seen = Set(pointsSeen(path: path))
                let adjs = self.neighbors(for: path.vertex)
                return adjs.filter({!seen.contains($0.v)})
            },
            isDestination: { vertex in
                if vertex.v == end && vertex.steps > longest {
                    longest = vertex.steps
                }
                return false
            },
            in: self)

        return longest
    }

    func stepsInTheLongestHikeSlopsAsNormalPaths() -> Int {
        var longest = 0
        let _ = DijkstraSearch.findPath(
            from: Node(v: start, steps: 0),
            neighbors: { path in
                let seen = Set(pointsSeen(path: path))
                let adjs = self.neighborsWithSlopesAsNormal(for: path.vertex)
                return adjs.filter({!seen.contains($0.v)})
            },
            isDestination: { vertex in
                if vertex.v == end {
                    print(vertex.steps)
                }
                if vertex.v == end && vertex.steps > longest {
                    longest = vertex.steps
                }
                return false
            },
            in: self)

        return longest
    }

    func pointsSeen(path: PathNode<Vertex>) -> [SIMD2<Int>] {
        var seen = [SIMD2<Int>]()
        path.iteratePath { _, node, _ in seen.append(node.vertex.v) }
        return seen
    }

    struct Node: Hashable {
        let v: SIMD2<Int>
        let steps: Int
    }

    typealias Cost = Int
    typealias Vertex = Node

    func cost(from: Vertex, to: Vertex) -> Cost {
        -1
    }

    func neighbors(for vertex: Vertex) -> [Vertex] {
        switch grid.char(at: vertex.v) {
        case "^": return [Node(v: vertex.v &+ Grid.Directions.north, steps: vertex.steps + 1)]
        case ">": return [Node(v: vertex.v &+ Grid.Directions.east, steps: vertex.steps + 1)]
        case "v": return [Node(v: vertex.v &+ Grid.Directions.south, steps: vertex.steps + 1)]
        case "<": return [Node(v: vertex.v &+ Grid.Directions.west, steps: vertex.steps + 1)]
        default:
            return grid.neighbors(to: vertex.v)
                .filter { grid.char(at: $0) != "#" }
                .map { Node(v: $0, steps: vertex.steps + 1) }
        }
    }

    func neighborsWithSlopesAsNormal(for vertex: Vertex) -> [Vertex] {
        return grid.neighbors(to: vertex.v)
            .filter { grid.char(at: $0) != "#" }
            .map { Node(v: $0, steps: vertex.steps + 1) }
    }
}
