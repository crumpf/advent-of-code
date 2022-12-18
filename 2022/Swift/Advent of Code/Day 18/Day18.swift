//
//  Day18.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/18/22.
//

import Foundation

class Day18: Day {
    func part1() -> String {
        "\(surfaceAreaOfScannedLavaDroplets())"
    }
    
    func part2() -> String {
        "Not Implemented"
    }
    
    //What is the surface area of your scanned lava droplet?
    func surfaceAreaOfScannedLavaDroplets() -> Int {
        let cubes = makeCubes()
        for (n, cube) in cubes[0..<(cubes.count-1)].enumerated() {
            for cube2 in cubes[(n+1)..<cubes.count] where cube.isOrthogonallyAdjacent(to: cube2) {
                cube.numberOfSidesVisible -= 1
                cube2.numberOfSidesVisible -= 1
            }
        }
        return cubes.reduce(0) { $0 + $1.numberOfSidesVisible}
    }
    
    typealias Point3D = SIMD3<Int>
    
    class Cube {
        let position: Point3D
        var numberOfSidesVisible = 6
        
        init(position: Point3D, numberOfSidesVisible: Int = 6) {
            self.position = position
            self.numberOfSidesVisible = numberOfSidesVisible
        }
        
        func isOrthogonallyAdjacent(to other: Cube) -> Bool {
            let deltaX = abs(position.x - other.position.x)
            let deltaY = abs(position.y - other.position.y)
            let deltaZ = abs(position.z - other.position.z)
            return 1 == deltaX + deltaY + deltaZ
        }
    }
    
    private func makeCubes() -> [Cube] {
        input.lines().map {
            let comps = $0.components(separatedBy: ",")
            let point = Point3D(Int(comps[0])!, Int(comps[1])!, Int(comps[2])!)
            return Cube(position: point)
        }
    }
    
}
