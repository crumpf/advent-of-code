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
        let expansionScale = 1_000_000
        let image = makeImage(input: input)
        let expanded = mapExpandedSpace(image: image)
        let galaxies = galaxyLocations(in: expanded)
        let sumOfShortestPathsBetweenAllGalaxies = galaxies.enumerated().map { (offset, gStart) in
            galaxies.dropFirst(offset + 1).reduce(0) { partialResult, gEnd in
                var distance = 0
                var x = gStart.x, y = gStart.y
                while y != gEnd.y {
                    y += gEnd.y > gStart.y ? 1 : -1
                    distance += expanded[y][x] == "+" ? expansionScale : 1
                }
                while x != gEnd.x {
                    x += gEnd.x > gStart.x ? 1 : -1
                    distance += expanded[y][x] == "+" ? expansionScale : 1
                }
                return partialResult + distance
            }
        }.reduce(0, +)
        return "\(sumOfShortestPathsBetweenAllGalaxies)"
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

    // map areas of expanded space with a new Character, "+"
    func mapExpandedSpace(image: Image) -> Image {
        var expanded = image
        for (y, row) in expanded.enumerated() {
            if !row.contains("#") {
                expanded[y] = Array(repeating: "+", count: row.count)
            }
        }
        for x in expanded.first!.indices {
            let col = expanded.map { $0[x] }
            if !col.contains("#") {
                for y in expanded.indices {
                    expanded[y][x] = "+"
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
