//
//  main.swift
//  AoC2019 Day 20
//
//  Created by Chris Rumpf on 1/10/20.
//  Copyright © 2020 Chris Rumpf. All rights reserved.
//

import Foundation

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

// --- Day 20: Donut Maze ---

// easier to work with [[String]] or [[Character]]?
//let map = fileInput.components(separatedBy: "\n").map { $0.map { String($0) } }
let map = fileInput.components(separatedBy: "\n").map { Array<Character>($0) }

for row in map {
    print(row.map { String($0) }.joined())
}

extension CharacterSet {
    func containsUnicodeScalars(of character: Character) -> Bool {
        return character.unicodeScalars.allSatisfy(contains(_:))
    }
}

func letterAt(x: Int, y: Int) -> Character? {
    guard map.indices.contains(y), map[y].indices.contains(x), CharacterSet.uppercaseLetters.containsUnicodeScalars(of: map[y][x]) else { return nil }
    return map[y][x]
}

func hasPassageAt(x: Int, y: Int) -> Bool {
    guard map.indices.contains(y), map[y].indices.contains(x) else { return false }
    return ".".contains(map[y][x])
}

func hasPassage(at loc: Location) -> Bool {
    hasPassageAt(x: loc.x, y: loc.y)
}

typealias Location = SIMD2<Int>

extension Location {
    func adjacents() -> [Location] {
        return [self &+ Location(0, -1),
                self &+ Location(1, 0),
                self &+ Location(0, 1),
                self &+ Location(-1, 0)]
    }
}

struct Door {
    let name: String
    let loc: Location
}

var doorCache: [String: Door] = [:]
var doorways: [Location: Door] = [:] // maps a door xy location to a destination door
var startDoor: Door?
var endDoor: Door?

func handleFoundDoor(_ door: Door) {
    if door.name == "AA" {
        startDoor = door
        return
    } else if door.name == "ZZ" {
        endDoor = door
        return
    }

    if let dyadDoor = doorCache[door.name] {
        doorways[door.loc] = dyadDoor
        doorways[dyadDoor.loc] = door
        doorCache[door.name] = nil
    } else {
        doorCache[door.name] = door
    }
}

// find magic doors
for (y, row) in map.enumerated() {
    guard y < map.count - 2 else { continue }
    for (x, c) in row.enumerated() {
        guard x < row.count - 1 else { continue }
        if CharacterSet.uppercaseLetters.containsUnicodeScalars(of: c) {
            if let bottom = letterAt(x: x, y: y + 1) {
                // found vertical door tag
                let name = String([c, bottom])
                let loc = hasPassageAt(x: x, y: y - 1) ? Location(x, y-1) : Location(x, y+2)
                handleFoundDoor(Door(name: name, loc: loc))
            } else if let right = letterAt(x: x + 1, y: y) {
                // found horizontal door tag
                let name = String([c, right])
                let loc = hasPassageAt(x: x - 1, y: y) ? Location(x-1, y) : Location(x+2, y)
                handleFoundDoor(Door(name: name, loc: loc))
            }
        }
    }
}

class Node {
    let location: Location
    var previous: Node? // the Node we got here from

    init(location: Location, previous: Node? = nil) {
        self.location = location
        self.previous = previous
    }

    func adjacents() -> [Node] {
        var adjacents = [Node(location: location &+ Location(0, -1), previous: self),
                         Node(location: location &+ Location(1, 0), previous: self),
                         Node(location: location &+ Location(0, 1), previous: self),
                         Node(location: location &+ Location(-1, 0), previous: self)]
        if let destDoor = doorways[location] {
            adjacents.append(Node(location: destDoor.loc, previous: self))
        }
        return adjacents
    }
}

// find shortest path to the goal node "ZZ" using BFS
func bfs(origin: Node) -> Node? {
    let queue = Queue<Node>()
    queue.enqueue(origin)
    var seen = Set<Location>([origin.location])

    while let node = queue.dequeue() {
        guard node.location != endDoor?.loc else {
            // woot! found the goal
            return node
        }

        for neighbor in node.adjacents() where !seen.contains(neighbor.location) && hasPassage(at: neighbor.location) {
            queue.enqueue(neighbor)
            seen.insert(neighbor.location)
        }


    }

    return nil
}

if let startDoor = startDoor {
    let goal = bfs(origin: Node(location: startDoor.loc))

    var steps = 0
    var resultMap = map
    var next = goal
    while next?.previous != nil, let n = next {
        steps += 1
        resultMap[n.location.y][n.location.x] = Character("@")
        next = next?.previous
    }

    for row in resultMap {
        print(row.map { String($0) }.joined())
    }

    print(goal?.location ?? "Goal not found!")
    print("Shortest number of steps to reach goal: \(steps)")
}

// part 2

// need to:
// - create 2 maps, one for outer doors and one for inner doors
// - location needs to be expanded to account for x y and z since we'll have levels that can be expressed along the z dimension
// - special case for z0 outer doors that they are walls
// - outer and inner doors move up or down levels

