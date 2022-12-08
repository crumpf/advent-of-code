//
//  Day08.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/07/2022.
//

import Foundation

class Day08: Day {
    func part1() -> String {
        return "\(numberOfTreesVisibleFromOutsideOfGrid(grid))"
    }
    
    func part2() -> String {
        return "Not Implemented"
    }
    
    lazy private(set) var grid = input.lines().map { $0.compactMap { Int(String($0))} }
    
    private func numberOfTreesVisibleFromOutsideOfGrid(_ grid: [[Int]]) -> Int {
        var seeSet = Set<GridLocation>()
        for (row, elem) in grid.enumerated() {
            for (col, _) in elem.enumerated() {
                if grid.canSee(row: row, col: col) {
                    seeSet.insert(GridLocation(row: row, col: col))
                }
            }
        }
        return seeSet.count
    }
}

extension [[Int]] {
    func canSee(row: Int, col: Int) -> Bool {
        guard row != 0, row != count - 1, col != 0, col != self[row].count - 1 else {
            return true
        }
        let height = self[row][col]
        for range in [0..<row, (row+1)..<count] {
            for rowIndex in range {
                if self[rowIndex][col] >= height {
                    break
                } else if rowIndex == range.upperBound - 1 {
                    return true
                }
            }
        }
        for range in [0..<col, (col+1)..<self[row].count] {
            for colIndex in range {
                if self[row][colIndex] >= height {
                    break
                } else if colIndex == range.upperBound - 1 {
                    return true
                }
            }
        }
        return false
    }
}
