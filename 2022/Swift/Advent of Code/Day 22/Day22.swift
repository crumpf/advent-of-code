//
//  Day22.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/22/22.
//

import Foundation

class Day22: Day {
    func part1() -> String {
        "\(finalPassword())"
    }
    
    func part2() -> String {
        "Not Implemented"
    }
    
    private func finalPassword() -> Int {
        let note = makeNote(from: input)
        var cursor = (point: note.startPoint!, facing: Facing.right)

        for step in note.path {
            switch step {
            case .move(let num):
                for _ in 1...num {
                    let next = note.next(from: cursor.point, facing: cursor.facing)!
                    if note.wallPoints.contains(next) {
                        break
                    }
                    cursor.point = next
                }
            case .turn(let dir):
                let value = (cursor.facing.rawValue + (dir == "R" ? 1 : Facing.allCases.count - 1)) % Facing.allCases.count
                cursor.facing = Facing(rawValue: value)!
            }
        }
        return 1000 * (cursor.point.y + 1) + 4 * (cursor.point.x + 1) + cursor.facing.rawValue
    }
    
    typealias Point = SIMD2<Int>
    
    struct Note {
        let map: [[Character]]
        let path: [Step]
        let openPoints: Set<Point>
        let wallPoints: Set<Point>
        let allPoints: Set<Point>
        var startPoint: Point? {
            map.first?.firstIndex(of: ".").map { Point($0, 0) }
        }
        
        init(map: [[Character]], path: [Step]) {
            self.map = map
            self.path = path
            var openPoints = Set<Point>()
            var wallPoints = Set<Point>()
            for (y, row) in map.enumerated() {
                for (x, tile) in row.enumerated() {
                    switch tile {
                    case ".": openPoints.insert(Point(x, y))
                    case "#": wallPoints.insert(Point(x, y))
                    default: continue
                    }
                }
            }
            self.openPoints = openPoints
            self.wallPoints = wallPoints
            self.allPoints = openPoints.union(wallPoints)
        }
        
        func next(from pt: Point, facing: Facing) -> Point? {
            switch facing {
            case .right:
                for offset in 1...map[pt.y].endIndex {
                    let x = (pt.x + offset) % map[pt.y].endIndex
                    let next = Point(x, pt.y)
                    if allPoints.contains(next) {
                        return next
                    }
                }
            case .down:
                for offset in 1...map.endIndex {
                    let y = (pt.y + offset) % map.endIndex
                    let next = Point(pt.x, y)
                    if allPoints.contains(next) {
                        return next
                    }
                }
            case .left:
                for offset in 1...map[pt.y].endIndex {
                    var x = pt.x - offset
                    if x < 0 {
                        x = map[pt.y].endIndex + x
                    }
                    let next = Point(x, pt.y)
                    if allPoints.contains(next) {
                        return next
                    }
                }
            case .up:
                for offset in 1...map.endIndex {
                    var y = pt.y - offset
                    if y < 0 {
                        y = map.endIndex + y
                    }
                    let next = Point(pt.x, y)
                    if allPoints.contains(next) {
                        return next
                    }
                }
            }
            return nil
        }
    }

    enum Step {
        case move(Int)
        case turn(Character)
    }

    enum Facing: Int, CaseIterable {
        case right = 0, down, left, up
    }

    private func makeNote(from input: String) -> Note {
        let splits = input.split(separator: "\n\n")
        let map = splits[0].split(separator: "\n").map { Array($0) }
        var path = [Step]()
        var accumulatedNum: Int?
        for c in splits[1] {
            if let num = Int(String(c)) {
                accumulatedNum = 10 * (accumulatedNum ?? 0) + num
            } else if c == "R" || c == "L" {
                if let num = accumulatedNum {
                    path.append(.move(num))
                    accumulatedNum = nil
                }
                path.append(.turn(c))
            }
        }
        if let accumulatedNum {
            path.append(.move(accumulatedNum))
        }
        return Note(map: map, path: path)
    }

}
