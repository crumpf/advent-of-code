//
//  DayX.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on MM/DD/YY.
//

import Foundation

class Day16: Day {
    func part1() -> String {
        let grid = makeGrid()
        let startBeam = Beam(location: SIMD2(0,0), from: SIMD2(-1,0))
        let energizedTiles = energizedTilesWhenBeamEntersGrid(grid, beam: startBeam)
        return "\(energizedTiles.count)"
    }
    
    func part2() -> String {
        let grid = makeGrid()
        var maxEnergized = 0
        let dims = grid.dimensions()
        let beams = (0..<dims.x).map { Beam(location: SIMD2($0,0), from: SIMD2($0,-1)) } +
                    (0..<dims.x).map { Beam(location: SIMD2($0,dims.y-1), from: SIMD2($0,dims.y)) } +
                    (0..<dims.y).map { Beam(location: SIMD2(0,$0), from: SIMD2(-1, $0)) } +
                    (0..<dims.y).map { Beam(location: SIMD2(dims.x-1,$0), from: SIMD2(dims.x,$0)) }
        for beam in beams {
            let energizedTiles = energizedTilesWhenBeamEntersGrid(grid, beam: beam)
            maxEnergized = max(maxEnergized, energizedTiles.count)
        }
        return("\(maxEnergized)")
    }

    private func makeGrid() -> Grid { input.lines().map(Array.init) }

    struct Beam: Hashable {
        let location: SIMD2<Int>
        let from: SIMD2<Int>
    }

    private func energizedTilesWhenBeamEntersGrid(_ grid: Grid, beam: Beam) -> Set<SIMD2<Int>> {
        var energizedTiles = Set<SIMD2<Int>>()
        var explored: Set<Beam> = [beam]
        var frontier = Stack<Beam>()
        frontier.push(beam)
        while let current = frontier.pop() {
            energizedTiles.insert(current.location)
            let nextBeams: [Beam]
            let heading = current.location &- current.from
            switch grid.char(at: current.location) {
            case ".":
                nextBeams = [Beam(location: current.location &+ heading, from: current.location)]
            case "/":
                let newVector: SIMD2<Int>
                if heading.y == 1 {
                    newVector = SIMD2(-1, 0)
                } else if heading.y == -1 {
                    newVector = SIMD2(1, 0)
                } else if heading.x == 1 {
                    newVector = SIMD2(0, -1)
                } else {
                    newVector = SIMD2(0, 1)
                }
                nextBeams = [Beam(location: current.location &+ newVector, from: current.location)]
            case "\\":
                let newVector: SIMD2<Int>
                if heading.y == 1 {
                    newVector = SIMD2(1, 0)
                } else if heading.y == -1 {
                    newVector = SIMD2(-1, 0)
                } else if heading.x == 1 {
                    newVector = SIMD2(0, 1)
                } else {
                    newVector = SIMD2(0, -1)
                }
                nextBeams = [Beam(location: current.location &+ newVector, from: current.location)]
            case "-":
                if heading.x != 0 {
                    nextBeams = [Beam(location: current.location &+ heading, from: current.location)]
                } else {
                    nextBeams = [
                        Beam(location: current.location &+ SIMD2(-1, 0), from: current.location),
                        Beam(location: current.location &+ SIMD2(1, 0), from: current.location)
                    ]
                }
            case "|":
                if heading.y != 0 {
                    nextBeams = [Beam(location: current.location &+ heading, from: current.location)]
                } else {
                    nextBeams = [
                        Beam(location: current.location &+ SIMD2(0, -1), from: current.location),
                        Beam(location: current.location &+ SIMD2(0, 1), from: current.location)
                    ]
                }
            default:
                continue
            }

            for next in nextBeams where !explored.contains(next) {
                if grid.contains(next.location) {
                    explored.insert(next)
                    frontier.push(next)
                }
            }
        }
        return energizedTiles
    }
}

fileprivate typealias Grid = [[Character]]

fileprivate extension Grid {
    func dimensions() -> (x: Int, y: Int) { (x: self[0].count, y: count) }

    func char(at vertex: SIMD2<Int>) -> Character { self[vertex.y][vertex.x] }

    func contains(_ vertex: SIMD2<Int>) -> Bool {
        vertex.y >= 0 && vertex.y < count && vertex.x >= 0 && vertex.x < self[0].count
    }
}
