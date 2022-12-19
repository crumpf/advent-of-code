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
        var count = 0
        let lava = LavaDroplet(scan: makeCubePoints())
        let start = Point3D(lava.domain.x.lowerBound, lava.domain.y.lowerBound, lava.domain.z.lowerBound)
        let _ = BreadthFirstSearch<LavaDroplet>.findPath(from: start, isDestination: { point in
            count += Set(point.orthogonalAdjacents()).intersection(lava.scan).count
            return false // exaustive search the domain
        }, in: lava)
        return count
    }
    
    typealias Point3D = SIMD3<Int>
    
    private func makeCubePoints() -> [Point3D] {
        input.lines().map {
            let comps = $0.components(separatedBy: ",")
            return Point3D(Int(comps[0])!, Int(comps[1])!, Int(comps[2])!)
        }
    }
    
    struct LavaDroplet: Pathfinding {
        // Implement Pathfinding
        typealias Vertex = Point3D
        func neighbors(for vertex: Point3D) -> [Point3D] {
            vertex.orthogonalAdjacents().filter { point in
                domain.x.contains(point.x) && domain.y.contains(point.y) && domain.z.contains(point.z) && !scan.contains(point)
            }
        }
        
        let scan: Set<Point3D>
        let domain: (x: ClosedRange<Int>, y: ClosedRange<Int>, z: ClosedRange<Int>)
    
        init(scan: [Point3D]) {
            var xmin = Int.max, xmax = Int.min, ymin = xmin, ymax = xmax, zmin = xmin, zmax = xmax
            scan.forEach { point in
                xmin = min(xmin, point.x)
                xmax = max(xmax, point.x)
                ymin = min(ymin, point.y)
                ymax = max(ymax, point.y)
                zmin = min(zmin, point.z)
                zmax = max(zmax, point.z)
            }
            
            self.scan = Set(scan)
            self.domain = (x: (xmin-1)...(xmax+1), y: (ymin-1)...(ymax+1), z: (zmin-1)...(zmax+1))
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
