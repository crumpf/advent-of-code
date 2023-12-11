//
//  Day10.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/10/23.
//

import Foundation

class Day10: Day {
    func part1() -> String {
        "\(findStepsToFarthestPointFromStart())"
    }
    
    func part2() -> String {
        "Not Implemented"
    }

    struct Map: Pathfinding {
        private let grid: [[Character]]
        let width: Int
        let height: Int

        init(input: String) {
            grid = input.lines().map(Array.init)
            height = grid.indices.upperBound
            width = grid.first!.indices.upperBound
        }

        func start() -> Vertex? {
            for (y, row) in grid.enumerated() {
                for (x, tile) in row.enumerated() {
                    if tile == "S" { return Vertex(x, y) }
                }
            }
            return nil
        }

        func valueAt(x: Int, y: Int) -> Character? {
            guard grid.indices.contains(y), grid[y].indices.contains(x) else { return nil }
            return grid[y][x]
        }

        func value(atPoint point: SIMD2<Int>) -> Character? {
            valueAt(x: point.x, y: point.y)
        }

        // MARK: Pathfinding
        typealias Vertex = SIMD2<Int>

        func neighbors(for vertex: Vertex) -> [Vertex] {
            let x = vertex.x, y = vertex.y
            let north = SIMD2(x,y-1), west = SIMD2(x-1,y), south = SIMD2(x, y+1), east = SIMD2(x+1,y)
            var neighbors: [Vertex] = []
            switch valueAt(x: vertex.x, y: vertex.y) {
            case "|":
                if let v = value(atPoint: north), "S|7F".contains(v) { neighbors.append(north) }
                if let v = value(atPoint: south), "S|LJ".contains(v) { neighbors.append(south) }
            case "-":
                if let v = value(atPoint: east), "S-7J".contains(v) { neighbors.append(east) }
                if let v = value(atPoint: west), "S-LF".contains(v) { neighbors.append(west) }
            case "L":
                if let v = value(atPoint: north), "S|7F".contains(v) { neighbors.append(north) }
                if let v = value(atPoint: east), "S-7J".contains(v) { neighbors.append(east) }
            case "J":
                if let v = value(atPoint: north), "S|7F".contains(v) { neighbors.append(north) }
                if let v = value(atPoint: west), "S-LF".contains(v) { neighbors.append(west) }
            case "7":
                if let v = value(atPoint: south), "S|LJ".contains(v) { neighbors.append(south) }
                if let v = value(atPoint: west), "S-LF".contains(v) { neighbors.append(west) }
            case "F":
                if let v = value(atPoint: south), "S|LJ".contains(v) { neighbors.append(south) }
                if let v = value(atPoint: east), "S-7J".contains(v) { neighbors.append(east) }
            case ".":
                return []
            case "S":
                if let v = value(atPoint: north), "S|7F".contains(v) { neighbors.append(north) }
                if let v = value(atPoint: south), "S|LJ".contains(v) { neighbors.append(south) }
                if let v = value(atPoint: east), "S-7J".contains(v) { neighbors.append(east) }
                if let v = value(atPoint: west), "S-LF".contains(v) { neighbors.append(west) }
            default:
                return []
            }

            return neighbors
        }
    }

    private func findStepsToFarthestPointFromStart() -> Int {
        let map = Map(input: input)
        let start = map.start()!
        if let goal = findS(from: start, in: map) {
            let steps = lengthOfPath(goal)
            return (steps + 1) / 2
        }
        return -1
    }

    // My strategy is to use a DFS from each of the neighbors of the start point, S, to find one of the other
    // neighbors that isn't the one the DFS began from. Then we can just tack on the start node as the final
    // goal node since we know that both where we begain and ended are adjacent to S.
    private func findS<Graph: Pathfinding>(from start: Graph.Vertex, in graph: Graph) -> PathNode<Graph.Vertex>? {
        let neighbors = graph.neighbors(for: start)
        for vertex in neighbors {
            if let goal = DepthFirstSearch.findPath(from: vertex, isDestination: { v in
                v != vertex && neighbors.contains(v)
            }, in: graph) {
                return PathNode(vertex: start, predecessor: goal)
            }
        }
        return nil
    }

    private func lengthOfPath<T>(_ path: PathNode<T>) -> Int {
        var steps = 0
        var n = path.predecessor
        while n != nil {
            steps += 1
            n = n?.predecessor
        }
        return steps
    }
}
