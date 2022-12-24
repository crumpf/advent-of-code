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
        "\(firstRoundWhereNoElfMoves())"
    }
    
    private func numberOfEmptyTilesInBoundingRect(afterNumberOfRounds rounds: Int) -> Int {
        let elfPoints = elfLocations(maxNumberOfRounds: rounds, startingAt: input).0
        var xmin = Int.max, xmax = Int.min, ymin = xmin, ymax = xmax
        elfPoints.forEach { point in
            xmin = min(xmin, point.x)
            xmax = max(xmax, point.x)
            ymin = min(ymin, point.y)
            ymax = max(ymax, point.y)
        }
        return (xmax - xmin + 1) * (ymax - ymin + 1) - elfPoints.count
    }
    
    private func firstRoundWhereNoElfMoves() -> Int {
        elfLocations(maxNumberOfRounds: 100000, startingAt: input).1
    }
    
    private func elfLocations(maxNumberOfRounds rounds: Int, startingAt input: String) -> ([Point], Int) {
        var elfPoints = startingElfPoints(from: input)
        var directionPriority: [Direction] = [.north, .south, .west, .east]
        
        for n in 1...rounds {
            let elfset = Set(elfPoints)
            var proposalCounts = [Point: Int]()
            // 1st 1/2
            let proposals: [Point?] = elfPoints.map { elf in
                if elfset.intersection(elf.surrounding()).isEmpty {
                    return nil
                }
            
                for dir in directionPriority {
                    let consider: [Point]
                    switch dir {
                    case .north:
                        consider = [Point(-1,-1), Point(0,-1), Point(1,-1)].map { elf &+ $0 }
                    case .south:
                        consider = [Point(-1,1), Point(0,1), Point(1,1)].map { elf &+ $0 }
                    case .west:
                        consider = [Point(-1,-1), Point(-1,0), Point(-1,1)].map { elf &+ $0 }
                    case .east:
                        consider = [Point(1,-1), Point(1,0), Point(1,1)].map { elf &+ $0 }
                    }
                    if elfset.intersection(consider).isEmpty {
                        proposalCounts[consider[1]] = 1 + (proposalCounts[consider[1]] ?? 0)
                        return consider[1]
                    }
                }
                return nil
            }
            
            // 2nd 1/2
            var anyMoved = false
            elfPoints = zip(elfPoints, proposals).map({ (elf, proposal) in
                guard let proposal, proposalCounts[proposal] == 1 else {
                    return elf
                }
                anyMoved = true
                return proposal
            })
            if !anyMoved {
                return (elfPoints, n)
            }
            
            directionPriority.append(directionPriority.removeFirst())
        }
        
        return (elfPoints, rounds)
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
        [Self(-1, -1), Self(0, -1), Self(1, -1), Self(-1, 0), Self(1, 0), Self(-1, 1), Self(0, 1), Self(1, 1)]
            .map { self &+ $0 }
    }
}
