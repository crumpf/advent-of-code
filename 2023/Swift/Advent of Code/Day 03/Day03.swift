//
//  Day03.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/04/23.
//
// --- Day 3: Gear Ratios ---

import Foundation

class Day03: Day {
    func part1() -> String {
        "\(sumOfAllPartNumbers())"
    }
    
    func part2() -> String {
        "\(sumOfAllGearRatios())"
    }
    
    struct Coord2D: Hashable {
        let x, y: Int
        
        func adjacents() -> [Coord2D] {
            [Coord2D(x: x-1, y: y-1),
             Coord2D(x: x-1, y: y),
             Coord2D(x: x-1, y: y+1),
             Coord2D(x: x,   y: y-1),
             Coord2D(x: x,   y: y+1),
             Coord2D(x: x+1, y: y-1),
             Coord2D(x: x+1, y: y),
             Coord2D(x: x+1, y: y+1)]
        }
    }
    
    private func sumOfAllPartNumbers() -> Int {
        partsList(foundIn: makeGrid())
            .map { $0.num }
            .reduce(0, +)
    }
    
    private func sumOfAllGearRatios() -> Int {
        let grid = makeGrid()
        var partsList = partsList(foundIn: grid)
        var result = 0
        while !partsList.isEmpty {
            let part = partsList.removeFirst()
            let gearCoords = part.adjacents.filter { coord in
                grid.char(at: coord) == "*"
            }
            partsList.filter {
                !$0.adjacents.intersection(gearCoords).isEmpty
            }.forEach { otherPart in
                result += part.num * otherPart.num
            }
        }
        return result
    }
    
    private func makeGrid() -> Grid { input.lines().map(Array.init) }
    
    private func partsList(foundIn grid: Grid) -> [(num: Int, adjacents: Set<Coord2D>)] {
        var partsList = [(num: Int, adjacents: Set<Coord2D>)]()
        
        for (y, row) in grid.enumerated() {
            var num: Int?
            var adjacents = Set<Coord2D>()
            for (x, c) in row.enumerated() {
                if c.isNumber {
                    let digit = Int(String(c))!
                    if num != nil {
                        num = num! * 10 + digit
                    } else {
                        // start of new number
                        num = digit
                    }
                    
                    adjacents.formUnion(grid.adjacents(to: Coord2D(x: x, y: y)))
                } else if num != nil {
                    // end of the number
                    if grid.anySymbols(for: Array(adjacents)) {
                        partsList.append((num: num!, adjacents: adjacents))
                    }
                    num = nil
                    adjacents.removeAll()
                }
            }
            // end of line check
            if num != nil {
                if grid.anySymbols(for: Array(adjacents)) {
                    partsList.append((num: num!, adjacents: adjacents))
                }
                num = nil
                adjacents.removeAll()
            }
        }
        
        return partsList
    }
}

fileprivate typealias Grid = [[Character]]

fileprivate extension Grid {
    func dimensions() -> (x: Int, y: Int) { (x: self[0].count, y: count) }
    
    func char(at coord: Day03.Coord2D) -> Character { self[coord.y][coord.x] }
    
    func adjacents(to: Day03.Coord2D) -> [Day03.Coord2D] {
        return to.adjacents().filter {
            let dims = dimensions()
            return (0..<dims.x).contains($0.x) && (0..<dims.y).contains($0.y)
        }
    }
    
    func anySymbols(for coords: [Day03.Coord2D]) -> Bool {
        coords.contains {
            let c = char(at: $0)
            return c != "." && !c.isNumber
        }
    }
}
