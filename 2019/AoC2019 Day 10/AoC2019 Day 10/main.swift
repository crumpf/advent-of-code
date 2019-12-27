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

let asteroidCartesian = asteroidLocations(input: fileInput.components(separatedBy: "\n"))
let best = findBestLocation(asteroids: asteroidCartesian)
print(best)

// Part 2

// return the coordinate of the last vaporized asteroid (count)
func vaporize(asteroids: [Cartesian], count: Int) -> Cartesian? {
    let best = findBestLocation(asteroids: asteroids)
    var polars = asteroids.compactMap {
        best.coord.polar(to: $0)
    }
    var remaining = count
    var visible = [Double:Polar]()
    var last: Polar?

    while remaining > 0 {
        visible.removeAll()
        for coord in polars {
            guard !coord.theta.isNaN else {
                continue
            }
            if let exist = visible[coord.theta], coord.r < exist.r {
                continue
            }
            visible[coord.theta] = coord
        }

        let sorted = visible.values.sorted { (a, b) -> Bool in
            // The laser starts by pointing up and always rotates clockwise, vaporizing any asteroid it hits
            // note: since x increases left to right and y increases top to bottom, our laser sweep quadrants go
            // clockwise instead of counterclockwise
            // Q3 | Q4
            // -------
            // Q2 | Q1
            if a.theta >= .pi * 3 / 2 {
                if b.theta >= .pi * 3 / 2 {
                    return a.theta < b.theta
                } else {
                    return true
                }
            } else if b.theta >= .pi * 3 / 2 {
                return false
            } else {
                return a.theta < b.theta
            }
        }

        if sorted.count < remaining {
            last = sorted.last
            polars = Array(Set(polars).subtracting(sorted))
            remaining -= sorted.count
            print(sorted.count)
        } else {
            last = sorted[remaining-1]
            polars = Array(Set(polars).subtracting(sorted[0..<remaining]))
            remaining = 0
        }
    }

    if let last = last {
        let c = last.cartesian(rounded: 0)
        print(c)
        return Cartesian(x:c.x + best.coord.x, y:c.y + best.coord.y)
    }
    return nil
}

if let lastVaporized = vaporize(asteroids: asteroidCartesian, count: 200) {
    print("asteroid #200 vaporized at \(lastVaporized), result: \(lastVaporized.x * 100 + lastVaporized.y)")
}
