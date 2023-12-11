//
//  Day11.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/23.
//
//  --- Day 11: Cosmic Expansion ---

import Foundation

class Day11: Day {
    func part1() -> String {
        let image = makeImage(input: input)
        let expanded = expand(image: image)
        let galaxies = galaxyLocations(in: expanded)
        let sumOfShortestPathsBetweenAllGalaxies = galaxies.enumerated().map { gStart in
            galaxies.dropFirst(gStart.offset + 1).reduce(0) { partialResult, gEnd in
                let diff = gStart.element &- gEnd
                return partialResult + abs(diff.x) + abs(diff.y)
            }
        }.reduce(0, +)
        return "\(sumOfShortestPathsBetweenAllGalaxies)"
    }
    
    func part2() -> String {
        "Not Implemented"
    }

    typealias Image = [[Character]]
    typealias Point = SIMD2<Int>

    func makeImage(input: String) -> Image {
        input.lines().map(Array.init)
    }

    func expand(image: Image) -> Image {
        var expanded = Image()
        for row in image {
            expanded.append(row)
            if !row.contains("#") { expanded.append(row) }
        }
        for x in image.first!.indices.reversed() {
            let col = image.map { $0[x] }
            if !col.contains("#") {
                for y in expanded.indices {
                    expanded[y].insert(".", at: x)
                }
            }
        }
        return expanded
    }

    func galaxyLocations(in image: Image) -> [Point] {
        var points: [Point] = []
        for (y, row) in image.enumerated() {
            for (x, value) in row.enumerated() {
                if value == "#" { points.append(Point(x, y)) }
            }
        }
        return points
    }
}
