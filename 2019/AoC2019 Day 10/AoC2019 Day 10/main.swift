//
//  main.swift
//  AoC2019 Day 10
//
//  Created by Chris Rumpf on 12/26/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

import Foundation

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

// Day 10: Monitoring Station

// Your job is to figure out which asteroid would be the best place to build a new monitoring station. A monitoring station can detect any asteroid to which it has direct line of sight - that is, there cannot be another asteroid exactly between them. This line of sight can be at any angle, not just lines aligned to the grid or diagonally. The best location is the asteroid that can detect the largest number of other asteroids.

// possible solution: for each asteroid on the map, figure out the polar coordinates to all the other asteroids on the maps, then the total of the other asteroids that can be seen is the number of unique polar angles to the other asteroids.

func asteroidLocations(input: [String]) -> [Cartesian] {
    input.compactMap { $0.isEmpty ? nil : $0}.enumerated().flatMap { (y, row) -> [Cartesian] in
        row.enumerated().compactMap { (x, c) -> Cartesian? in
            c == "#" ? Cartesian(x: Double(x), y: Double(y)) : nil
        }
    }
}

extension Double {
    func roundedPrecision(_ digits: Int) -> Double? {
        let fmt = "%.\(digits)f"
        let str = String(format: fmt, self)
        return Double(str)
    }
}

func findBestLocation(asteroids: [Cartesian]) -> (coord: Cartesian, count: Int) {
    var best = (Cartesian(x: 0, y: 0), 0)
    var most = Int.min
    for (i, a0) in asteroids.enumerated() {
        let polars = asteroids.enumerated().compactMap { (j, a1) -> Polar? in
            a0.polar(to: a1)
        }
        let uniqueAngles = Set<Double>(polars.compactMap { !$0.theta.isNaN ? $0.theta.roundedPrecision(4) : nil })
        if uniqueAngles.count > most {
            most = uniqueAngles.count
            best = (a0, most)
        }
    }
    return best
}

//let t1 = "......#.#.\n#..#.#....\n..#######.\n.#.#.###..\n.#..#.....\n..#....#.#\n#..#....#.\n.##.#..###\n##...#..#.\n.#....####"
//let t1 = "#.#...#.#.\n.###....#.\n.#....#...\n##.#.#.#.#\n....#.#.#.\n.##..###.#\n..#...##..\n..##....##\n......#...\n.####.###."
//let t1 = ".#..#..###\n####.###.#\n....###.#.\n..###.##.#\n##.##.#.#.\n....###..#\n..#.#..#.#\n#..#.#.###\n.##...##.#\n.....#.#.."
//let a1 = asteroidLocations(input: t1.components(separatedBy: "\n"))
//let b1 = findBestLocation(asteroids: a1)
//print(b1)

let asteroidCartesian = asteroidLocations(input: fileInput.components(separatedBy: "\n"))
let best = findBestLocation(asteroids: asteroidCartesian)
print(best)
