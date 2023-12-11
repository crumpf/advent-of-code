//
//  Day10.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/10/23.
//
//  --- Day 10: Pipe Maze ---

import Foundation

class Day10: Day {
    func part1() -> String {
        "\(findStepsToFarthestPointFromStart())"
    }
    
    func part2() -> String {
        "\(tilesEnclosedByTheLoop())"
    }

    struct Map: Pathfinding {
        private var grid: [[Character]]
        let width: Int
        let height: Int
        private(set) var startLoop: PathNode<Vertex>?
        private(set) var loopVertices = [Vertex]()

        init(input: String) {
            grid = input.lines().map(Array.init)
            height = grid.indices.upperBound
            width = grid.first!.indices.upperBound

            if let v = startVertex() {
                startLoop = findLoop(from: v, in: self)
            }
            // figure out what type of pipe connection S is
            if let startLoop {
                var n: PathNode<Vertex>? = startLoop
                while n != nil {
                    loopVertices.append(n!.vertex)
                    n = n?.predecessor
                }
                let s = loopVertices[0], v1 = loopVertices[1], v2 = loopVertices.last!
                grid[s.y][s.x] = pipeConnection(s: s, v1: v1, v2: v2)
            }
        }

        private func startVertex() -> Vertex? {
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

        func value(atVertex vertex: Vertex) -> Character? {
            valueAt(x: vertex.x, y: vertex.y)
        }

        private func pipeConnection(s: SIMD2<Int>, v1: SIMD2<Int>, v2: SIMD2<Int>) -> Character {
            let neighbors = Set([v1, v2])
            if      neighbors == Set([s &+ SIMD2(0,-1), s &+ SIMD2( 0,1)]) { return "|" }
            else if neighbors == Set([s &+ SIMD2(-1,0), s &+ SIMD2( 1,0)]) { return "-" }
            else if neighbors == Set([s &+ SIMD2(0,-1), s &+ SIMD2( 1,0)]) { return "L" }
            else if neighbors == Set([s &+ SIMD2(0,-1), s &+ SIMD2(-1,0)]) { return "J" }
            else if neighbors == Set([s &+ SIMD2(0, 1), s &+ SIMD2(-1,0)]) { return "7" }
            else if neighbors == Set([s &+ SIMD2(0, 1), s &+ SIMD2( 1,0)]) { return "F" }
            return "😱"
        }

        // MARK: Pathfinding
        typealias Vertex = SIMD2<Int>

        func neighbors(for vertex: Vertex) -> [Vertex] {
            let x = vertex.x, y = vertex.y
            let north = SIMD2(x,y-1), west = SIMD2(x-1,y), south = SIMD2(x, y+1), east = SIMD2(x+1,y)
            var neighbors: [Vertex] = []
            switch valueAt(x: vertex.x, y: vertex.y) {
            case "|":
                if let v = value(atVertex: north), "S|7F".contains(v) { neighbors.append(north) }
                if let v = value(atVertex: south), "S|LJ".contains(v) { neighbors.append(south) }
            case "-":
                if let v = value(atVertex: east), "S-7J".contains(v) { neighbors.append(east) }
                if let v = value(atVertex: west), "S-LF".contains(v) { neighbors.append(west) }
            case "L":
                if let v = value(atVertex: north), "S|7F".contains(v) { neighbors.append(north) }
                if let v = value(atVertex: east), "S-7J".contains(v) { neighbors.append(east) }
            case "J":
                if let v = value(atVertex: north), "S|7F".contains(v) { neighbors.append(north) }
                if let v = value(atVertex: west), "S-LF".contains(v) { neighbors.append(west) }
            case "7":
                if let v = value(atVertex: south), "S|LJ".contains(v) { neighbors.append(south) }
                if let v = value(atVertex: west), "S-LF".contains(v) { neighbors.append(west) }
            case "F":
                if let v = value(atVertex: south), "S|LJ".contains(v) { neighbors.append(south) }
                if let v = value(atVertex: east), "S-7J".contains(v) { neighbors.append(east) }
            case ".":
                return []
            case "S":
                if let v = value(atVertex: north), "S|7F".contains(v) { neighbors.append(north) }
                if let v = value(atVertex: south), "S|LJ".contains(v) { neighbors.append(south) }
                if let v = value(atVertex: east), "S-7J".contains(v) { neighbors.append(east) }
                if let v = value(atVertex: west), "S-LF".contains(v) { neighbors.append(west) }
            default:
                return []
            }

            return neighbors
        }

        // My strategy is to use a DFS from each of the neighbors of the start point, S, to find one of the other
        // neighbors that isn't the one the DFS began from. Then we can just tack on the start node as the final
        // goal node since we know that both where we begain and ended are adjacent to S. The returned PathNode
        // will be node S with predecessors running back to an adjacent node of S.
        private func findLoop<Graph: Pathfinding>(from start: Graph.Vertex, in graph: Graph) -> PathNode<Graph.Vertex>? {
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
    }

    private func findStepsToFarthestPointFromStart() -> Int {
        let map = Map(input: input)
        if let s = map.startLoop {
            let steps = lengthOfPath(s)
            return (steps + 1) / 2
        }
        return -1
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

    private func tilesEnclosedByTheLoop() -> Int {
        let map = Map(input: input)
        // shoot rays horizontally through the map rows, inner|outer should swap every time we pass a boundary of our loop
        var outer = 0, inner = 0
        for y in 0..<map.height {
            var isInner = false
            var lastVert: Character?
            for x in 0..<map.width {
                let v = Map.Vertex(x, y)
                if let c = map.value(atVertex: v) {
                    let isLoopVertex = map.loopVertices.contains(v)
                    if c == "." || !isLoopVertex {
                        if isInner { inner += 1 } else { outer += 1 }
                    } else if isLoopVertex && "|LJ7F".contains(c) {
                        switch c {
                        case "|": isInner = !isInner; lastVert = nil
                        case "L": isInner = !isInner; lastVert = c
                        case "J": if lastVert == "L" { isInner = !isInner }; lastVert = nil
                        case "7": if lastVert == "F" { isInner = !isInner }; lastVert = nil
                        case "F": isInner = !isInner; lastVert = c
                        default: break
                        }
                    }
                }
            }
        }
        print("inner:\(inner) outer:\(outer)")

        return -1
    }

}
