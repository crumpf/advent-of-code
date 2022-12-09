//
//  Day01.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 11/30/22.
//

import Foundation

class Day01: Day {
    
    func part1() -> String {
        "\(totalCaloriesOfElfCarryingTheMostCalories() ?? 0)"
    }
    
    func part2() -> String {
        "\(totalCaloriesOfTop3ElvesCarryingTheMostCalories())"
    }
    
    private(set) lazy var elfCalorieLists = input
        .components(separatedBy: "\n\n")
        .map {
            $0.components(separatedBy: .newlines).compactMap { Int($0) }
        }
    
    private func totalCaloriesOfElfCarryingTheMostCalories() -> Int? {
        elfCalorieLists.map({ $0.reduce(0, +) }).max()
    }
    
    private func totalCaloriesOfTop3ElvesCarryingTheMostCalories() -> Int {
        elfCalorieLists.map { $0.reduce(0, +) }.sorted(by: >)[0..<3].reduce(0, +)
    }
    
}
