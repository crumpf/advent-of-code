//
//  Day12.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/22.
//

import Foundation

class Day12: Day {
    func part1() -> String {
        "\(fewestStepsToReachTheGoal(analyzingDeviceReading: readFromHandheldDevice()) ?? -1)"
    }
    
    func part2() -> String {
        "\(fewestStepsToReachTheGoalFromAnyLowestElevation(analyzingDeviceReading: readFromHandheldDevice()) ?? -1)"
    }
    
    struct DeviceReading: Pathfinding {
        // Implement Pathfinding Protocol
        typealias Vertex = GridLocation
        func neighbors(for vertex: GridLocation) -> [GridLocation] {
            vertex.orthogonal()
                .filter {
                    if let locElev = elevationAt(row: vertex.row, col: vertex.col),
                       let orthElev = elevationAt(row: $0.row, col: $0.col) {
                        return orthElev - locElev <= 1
                    }
                    return false
                }
        }
        
        let elevationMap: [[Int]]
        let start: GridLocation
        let end: GridLocation
        
        func elevationAt(row: Int, col: Int) -> Int? {
            guard elevationMap.indices.contains(row), elevationMap[row].indices.contains(col) else {
                return nil
            }
            return elevationMap[row][col]
        }
    }
    
    typealias Visit = (from: TreeNode<GridLocation>, weight: Int)
    
    private func readFromHandheldDevice() -> DeviceReading {
        var s = GridLocation(row: 0, col: 0), e = GridLocation(row: 0, col: 0)
        let heightmap = input.lines().enumerated().map { row in
            row.element.enumerated().map { col in
                switch col.element {
                case "S":
                    s = GridLocation(row: row.offset, col: col.offset)
                    return 0
                case "E":
                    e = GridLocation(row: row.offset, col: col.offset)
                    return 25
                default:
                    return Int(col.element.asciiValue! - Character("a").asciiValue!)
                }
            }
        }
        return DeviceReading(
            elevationMap: heightmap,
            start: s,
            end: e
        )
    }
    
    private func fewestStepsToReachTheGoal(analyzingDeviceReading reading: DeviceReading) -> Int? {
        fewestStepsToReachTheGoal(analyzingDeviceReading: reading, startingAt: reading.start)
    }
    
    private func fewestStepsToReachTheGoal(analyzingDeviceReading reading: DeviceReading, startingAt start: GridLocation) -> Int? {
        let solution = BreadthFirstSearch.findPath(from: start, to: reading.end, in: reading)
        var stepsToReach: Int?
        var n = solution?.predecessor
        while n != nil {
            stepsToReach = 1 + (stepsToReach ?? 0)
            n = n?.predecessor
        }
        return stepsToReach
    }
    
    private func fewestStepsToReachTheGoalFromAnyLowestElevation(analyzingDeviceReading reading: DeviceReading) -> Int? {
        var fewest: Int?
        var bestStart = GridLocation.zero
        for row in reading.elevationMap.enumerated() {
            for col in row.element.enumerated() {
                let loc = GridLocation(row: row.offset, col: col.offset)
                if let elevation = reading.elevationAt(row: row.offset, col: col.offset),
                   elevation == 0,
                   let steps = fewestStepsToReachTheGoal(
                    analyzingDeviceReading: reading,
                    startingAt: loc
                   ) {
                    if steps < (fewest ?? Int.max) {
                        fewest = steps
                        bestStart = GridLocation(row: row.offset, col: col.offset)
                    }
                }
            }
        }
        print("location: \(bestStart), has fewest steps: \(fewest ?? -1)")
        return fewest
    }
    
}
