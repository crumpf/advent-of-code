//
//  main.swift
//  AoC2019 Day 15
//
//  Created by Chris Rumpf on 1/1/20.
//  Copyright © 2020 Chris Rumpf. All rights reserved.
//

import Foundation

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

// --- Day 15: Oxygen System ---

/*
 The remote control program executes the following steps in a loop forever:

 - Accept a movement command via an input instruction.
 - Send the movement command to the repair droid.
 - Wait for the repair droid to finish the movement operation.
 - Report on the status of the repair droid via an output instruction.

 Only four movement commands are understood: north (1), south (2), west (3), and east (4).

 The repair droid can reply with any of the following status codes:

 0: The repair droid hit a wall. Its position has not changed.
 1: The repair droid has moved one step in the requested direction.
 2: The repair droid has moved one step in the requested direction; its new position is the location of the oxygen system.
*/

typealias Location = SIMD2<Int>

extension Location {
    func adjacents() -> [Location] {
        return [self &+ Location(0, -1),
                self &+ Location(1, 0),
                self &+ Location(0, 1),
                self &+ Location(-1, 0)]
    }
}

enum MovementCommand: Int {
    case north = 1
    case south
    case west
    case east
}

enum StatusCode: Int {
    case hitWall = 0
    case moved
    case foundOxygenSystem
}

enum NodeState {
    case wall
    case empty
    case goal
}

class Node {
    let location: Location
    var state: NodeState?
    var previous: Node? // the Node we got here from

    init(location: Location, previous: Node? = nil) {
        self.location = location
        self.previous = previous
    }

    func adjacents() -> [Node] {
        return [Node(location: location &+ Location(0, -1), previous: self),
                Node(location: location &+ Location(1, 0), previous: self),
                Node(location: location &+ Location(0, 1), previous: self),
                Node(location: location &+ Location(-1, 0), previous: self)]
    }

    func commandToReach(from sourceLocation: Location) -> MovementCommand? {
        let difference = location &- sourceLocation
        if difference == Location(0, -1) {
            return .north
        } else if difference == Location(1, 0) {
            return .east
        } else if difference == Location(0, 1) {
            return .south
        } else if difference == Location(-1, 0) {
            return .west
        } else {
            return nil
        }
    }
}

class RepairDroid {
    init(program: [Int]) {
        self.program = program
        self.computer = IntcodeComputer(program: program)
        self.currentNode = Node(location: Location(0, 0))
    }

    private let computer: IntcodeComputer
    private let program: [Int]
    private(set) var currentNode: Node

    /**
     Returns the x,y offset of the Oxygen Sensor from the robot's starting position.
     */
    func findOxygenSensor() -> Node? {
        let result = dfs(origin: Node(location: Location(0, 0)))
        return result.goal
    }

    func findOxygenSensorAndFullLocations() -> (Node?, Set<Location>) {
        let result = dfs(origin: Node(location: Location(0, 0)), trackWholeMap: true)
        return result
    }

    private func dfs(origin: Node, trackWholeMap: Bool = false) -> (goal: Node?, locations: Set<Location>) {
        var goal: Node?
        var mapLocations = Set<Location>()

        origin.state = .empty
        currentNode = origin

        let stack = Stack<Node>()
        stack.push(origin)
        var trackedLocations = Set<Location>([origin.location])

        computer.reset()
        _ = computer.run(input: [])

        while computer.state != .halted && !stack.isEmpty {
            if computer.state == .waitingForInput {
                if let node = stack.pop() {
                    if let command = node.commandToReach(from: currentNode.location) {
                        if let response = computer.run(input: [command.rawValue]), let statusCode = StatusCode(rawValue: response) {
                            switch statusCode {
                            case .hitWall:
                                node.state = .wall
                                continue
                            case .moved:
                                currentNode = node
                                node.state = .empty
                                mapLocations.insert(node.location)
                            case .foundOxygenSystem:
                                currentNode = node
                                node.state = .goal
                                mapLocations.insert(node.location)
                                goal = node
                                if !trackWholeMap {
                                    return (goal, mapLocations)
                                }
                            }
                        }
                    } else if currentNode.location != origin.location {
//                        print("cannot reach node \(node.location) from current location \(currentNode.location), need to backtrack to \(node.previous!.location)")
                        while currentNode.location != node.previous!.location {
                            guard let previous = currentNode.previous, let command = previous.commandToReach(from: currentNode.location) else {
                                print("Error, cannot backtrack!")
                                return (nil, mapLocations)
                            }
                            if let response = computer.run(input: [command.rawValue]), let statusCode = StatusCode(rawValue: response) {
                                guard statusCode == .moved else {
                                    print("Error, failure backtracking. status code = \(statusCode)")
                                    return (nil, mapLocations)
                                }
                                currentNode = previous
                            }
                            _ = computer.run(input: []) // make sure the computer is waiting on input
                        }
                        stack.push(node)
//                        print("got back, let's go...")
                        continue
                    }

                    // figure out the places we can go next from this node
                    // for those new nodes not explored, push them on the stack
                    for neighbor in node.adjacents() where !trackedLocations.contains(neighbor.location) {
                        trackedLocations.insert(neighbor.location)
                        stack.push(neighbor)
                    }
                }
            } else {
                _ = computer.run(input: []) // make sure the computer is waiting on input
            }
        }

        return (goal, mapLocations)
    }
}

func part1() {
    let program = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }
    let droid = RepairDroid(program: program)
    let sensorNode = droid.findOxygenSensor()
    var count = 0
    var n = sensorNode
    while n?.previous != nil {
        count += 1
        n = n?.previous
    }
    print("sensor is at node loc \(sensorNode?.location), \(count) steps away")
}

part1()

func printMap(_ map: Set<Location>, goal: Location) {
    var m = Array(repeating: Array(repeating: "#", count: 50), count: 50)
    for i in map {
        m[25 - i.y][25 - i.x] = "."
    }
    m[25 - goal.y][25 - goal.x] = "@"
    for row in m {
        print(row.reduce("", { (r, s) -> String in
            r + s
        }))
    }
}

func part2() {
    let program = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }
    let droid = RepairDroid(program: program)
    let result = droid.findOxygenSensorAndFullLocations()

    printMap(result.1, goal: result.0!.location)

    var minutes = 0
    var map = result.1
    var recentOxyLocs = [result.0!.location]
    while !map.isEmpty && !recentOxyLocs.isEmpty {
        var newOxyLocs = [Location]()
        map.subtract(recentOxyLocs)
        for loc in recentOxyLocs {
            for neighbor in loc.adjacents() where map.contains(neighbor) {
                newOxyLocs.append(neighbor)
            }
        }
        recentOxyLocs = newOxyLocs
        if !recentOxyLocs.isEmpty {
            minutes += 1
        }
    }
    print("number of minutes to fill map = \(minutes)")
}

part2()
