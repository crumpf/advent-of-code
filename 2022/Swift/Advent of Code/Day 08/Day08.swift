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
        return "\(highestScenicScoreForAnyTreeInGrid(grid))"
    }
    
    lazy private(set) var grid = input.lines().map { $0.compactMap { Int(String($0))} }
    
    private func numberOfTreesVisibleFromOutsideOfGrid(_ grid: [[Int]]) -> Int {
        var seeSet = Set<GridLocation>()
        for (row, elem) in grid.enumerated() {
            for (col, _) in elem.enumerated() {
                if grid.isTreeVisibleAt(row: row, col: col) {
                    seeSet.insert(GridLocation(row: row, col: col))
                }
            }
        }
        return seeSet.count
    }
    
    private func highestScenicScoreForAnyTreeInGrid(_ grid: [[Int]]) -> Int {
        var highest = 0
        for (row, elem) in grid.enumerated() {
            for (col, _) in elem.enumerated() {
                let score = grid.scenicScoreOfTreeAt(row: row, col: col)
                if score > highest {
                    highest = score
                }
            }
        }
        return highest
    }
}

extension [[Int]] {
    func isTreeVisibleAt(row: Int, col: Int) -> Bool {
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
    
    func scenicScoreOfTreeAt(row: Int, col: Int) -> Int {
        let height = self[row][col]
        var up = 0, down = 0, left = 0, right = 0
        for n in (0..<row).reversed() {
            up += 1
            if self[n][col] >= height { break }
        }
        for n in (row+1)..<count {
            down += 1
            if self[n][col] >= height { break }
        }
        for n in (0..<col).reversed() {
            left += 1
            if self[row][n] >= height { break }
        }
        for n in (col+1)..<self[row].count {
            right += 1
            if self[row][n] >= height { break }
        }
        return up * down * left * right
    }
}
