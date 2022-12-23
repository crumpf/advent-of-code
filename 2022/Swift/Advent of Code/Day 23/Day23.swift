//
//  Day23.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/23/22.
//

import Foundation

class Day23: Day {
    func part1() -> String {
        "\(numberOfEmptyTilesInBoundingRect(afterNumberOfRounds: 10))"
    }
    
    func part2() -> String {
        "Not Implemented"
    }
    
    private func numberOfEmptyTilesInBoundingRect(afterNumberOfRounds rounds: Int) -> Int {
        var elfPoints = startingElfPoints(from: input)
        var directionPriority: [Direction] = [.north, .south, .west, .east]
        
        for _ in 1...rounds {
            // 1st 1/2
            let proposals: [Point?] = elfPoints.map { elf in
                let elfset = Set(elfPoints)
                if elfset.intersection(elf.surrounding()).isEmpty {
                    return nil
                }
            
                for dir in directionPriority {
                    let consider: [Point]
                    switch dir {
                    case .north:
                        consider = [elf &+ Point(-1,-1), elf &+ Point(0,-1), elf &+ Point(1,-1)]
                    case .south:
                        consider = [elf &+ Point(-1,1), elf &+ Point(0,1), elf &+ Point(1,1)]
                    case .west:
                        consider = [elf &+ Point(-1,-1), elf &+ Point(-1,0), elf &+ Point(-1,1)]
                    case .east:
                        consider = [elf &+ Point(1,-1), elf &+ Point(1,0), elf &+ Point(1,1)]
                    }
                    if elfset.intersection(consider).isEmpty {
                        return consider[1]
                    }
                }
                return nil
            }
            
            // 2nd 1/2
            elfPoints = zip(elfPoints, proposals).map({ (elf, proposal) in
                guard let proposal, proposals.filter({ $0 == proposal }).count == 1 else {
                    return elf
                }
                return proposal
            })
            
            directionPriority.append(directionPriority.removeFirst())
        }
        
        var xmin = Int.max, xmax = Int.min, ymin = xmin, ymax = xmax
        elfPoints.forEach { point in
            xmin = min(xmin, point.x)
            xmax = max(xmax, point.x)
            ymin = min(ymin, point.y)
            ymax = max(ymax, point.y)
        }
        
        return (xmax - xmin + 1) * (ymax - ymin + 1) - elfPoints.count
    }
    
    enum Direction {
        case north, south, west, east
    }
    
    typealias Point = SIMD2<Int>
    
    private func startingElfPoints(from input: String) -> [Point] {
        var points = [Point]()
        for (y, line) in input.lines().enumerated() {
            for (x, c) in line.enumerated() where c == "#" {
                points.append(Point(x, y))
            }
        }
        return points
    }
}

private extension Day23.Point {
    func surrounding() -> [Self] {
        [self &+ Self(-1, -1),
         self &+ Self(0, -1),
         self &+ Self(1, -1),
         self &+ Self(-1, 0),
         self &+ Self(1, 0),
         self &+ Self(-1, 1),
         self &+ Self(0, 1),
         self &+ Self(1, 1)]
    }
}
