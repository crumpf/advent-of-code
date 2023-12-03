//
//  Puzzle.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/3/20.
//

/// This is the type to be subclassed to solve the puzzle for each Advent of Code day.
typealias Day = AdventBase & Puzzle

protocol Puzzle {
    func part1() -> String
    func part2() -> String
}

class AdventBase {
    let input: String
    
    init(input: String) {
        self.input = input
    }
}
