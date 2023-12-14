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
        let newRocks = dish.tilt(.north)
        let load = newRocks.enumerated().map { step in
            (newRocks.count - step.offset) * step.element.filter {c in c == "O"}.count
        }.reduce(0, +)
        return "\(load)"
    }
    
    func part2() -> String {
        "Not Implemented"
    }

    enum Direction {
        case north, west, south, east
    }

    struct Dish {
        let rocks: [[Character]]

        func tilt(_ direction: Direction) -> [[Character]] {
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
    }

    private func makeDish() -> Dish {
        let rocks = input.lines().map(Array.init)
        return Dish(rocks: rocks)
    }
}
