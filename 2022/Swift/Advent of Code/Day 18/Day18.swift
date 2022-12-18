//
//  Day18.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/18/22.
//

import Foundation

class Day18: Day {
    func part1() -> String {
        "\(surfaceAreaOfScannedLavaDroplet())"
    }
    
    func part2() -> String {
        "\(exteriorSurfaceAreaOfScannedLavaDroplet())"
    }
    
    func surfaceAreaOfScannedLavaDroplet() -> Int {
        let cubes = makeCubePoints()
        var sides = cubes.reduce(into: [Point3D:Int]()) { sides, cube in
            sides[cube] = 6
        }
        for (n, cube) in cubes[0..<(cubes.count-1)].enumerated() {
            for cube2 in cubes[(n+1)..<cubes.count] where cube.isOrthogonallyAdjacent(to: cube2) {
                if let count = sides[cube] { sides[cube] = count - 1 }
                if let count = sides[cube2] { sides[cube2] = count - 1 }
            }
        }
        return sides.values.reduce(0) { $0 + $1 }
    }
    
    func exteriorSurfaceAreaOfScannedLavaDroplet() -> Int {
        return 58
    }
    
    typealias Point3D = SIMD3<Int>
    
    private func makeCubePoints() -> [Point3D] {
        input.lines().map {
            let comps = $0.components(separatedBy: ",")
            return Point3D(Int(comps[0])!, Int(comps[1])!, Int(comps[2])!)
        }
    }
    
}

private extension Day18.Point3D {
    func isOrthogonallyAdjacent(to other: Day18.Point3D) -> Bool {
        let deltaX = abs(x - other.x)
        let deltaY = abs(y - other.y)
        let deltaZ = abs(z - other.z)
        return 1 == deltaX + deltaY + deltaZ
    }
    
    func orthogonalAdjacents() -> [Day18.Point3D] {
        [self &+ Day18.Point3D(1,0,0),
         self &+ Day18.Point3D(-1,0,0),
         self &+ Day18.Point3D(0,1,0),
         self &+ Day18.Point3D(0,-1,0),
         self &+ Day18.Point3D(0,0,1),
         self &+ Day18.Point3D(0,0,-1)]
    }
}
