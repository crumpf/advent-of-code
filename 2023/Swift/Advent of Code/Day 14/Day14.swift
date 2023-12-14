//
//  Day14.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/14/23.
//
//  --- Day 14: Parabolic Reflector Dish ---

import Foundation

class Day14: Day {
    func part1() -> String {
        let dish = makeDish()
        let newRocks = Dish.tilt(rocks: dish.rocks, .north)
        let load = load(rocks: newRocks)
        return "\(load)"
    }

    func part2() -> String {
        let cycles = 1_000_000_000
        let dish = makeDish()
        var cache = [[[Character]]]()
        var rocks = dish.rocks
        cache.append(rocks) // initial state, zero spins
        var loopStart = 0
        // Keep spinning the dish until we find a state of rocks that we've already seen.
        while true {
            rocks = Dish.spin(rocks: rocks)
            if let alreadySeen = cache.firstIndex(of: rocks) {
                loopStart = alreadySeen
                break
            }
            cache.append(rocks)
        }
        let loopLength = cache.count - loopStart
        let cycleIndex = loopStart + ((cycles-loopStart) % loopLength)
        return "\(load(rocks: cache[cycleIndex]))"
    }

    func load(rocks: [[Character]]) -> Int {
        rocks.enumerated().map { step in
            (rocks.count - step.offset) * step.element.filter {c in c == "O"}.count
        }.reduce(0, +)
    }

    enum Direction {
        case north, west, south, east
    }

    struct Dish {
        let rocks: [[Character]]

        static func tilt(rocks: [[Character]], _ direction: Direction) -> [[Character]] {
            var grid = rocks
            var moved = 0
            let xStride: StrideThrough<Int>
            let yStride: StrideThrough<Int>
            let vector: SIMD2<Int>
            switch direction {
            case .north:
                xStride = stride(from: 0, through: rocks[0].endIndex-1, by: 1)
                yStride = stride(from: 1, through: rocks.endIndex-1, by: 1)
                vector = SIMD2(0, -1)
            case .west:
                xStride = stride(from: 1, through: rocks[0].endIndex-1, by: 1)
                yStride = stride(from: 0, through: rocks.endIndex-1, by: 1)
                vector = SIMD2(-1, 0)
            case .south:
                xStride = stride(from: 0, through: rocks[0].endIndex-1, by: 1)
                yStride = stride(from: rocks.endIndex-2, through: 0, by: -1)
                vector = SIMD2(0, 1)
            case .east:
                xStride = stride(from: rocks[0].endIndex-2, through: 0, by: -1)
                yStride = stride(from: 0, through: rocks.endIndex-1, by: 1)
                vector = SIMD2(1, 0)
            }

            repeat {
                moved = 0
                for y in yStride {
                    for x in xStride {
                        let toCheck = SIMD2<Int>(x,y) &+ vector
                        if grid[y][x] == "O" && grid[toCheck.y][toCheck.x] == "." {
                            grid[toCheck.y][toCheck.x] = "O"
                            grid[y][x] = "."
                            moved += 1
                        }
                    }
                }
            } while moved > 0

            return grid
        }

        static func spin(rocks: [[Character]]) -> [[Character]] {
            var result = tilt(rocks: rocks, .north)
            result = tilt(rocks: result, .west)
            result = tilt(rocks: result, .south)
            return tilt(rocks: result, .east)
        }
    }

    private func makeDish() -> Dish {
        let rocks = input.lines().map(Array.init)
        return Dish(rocks: rocks)
    }
}
