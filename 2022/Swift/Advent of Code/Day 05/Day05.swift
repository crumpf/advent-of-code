//
//  Day05.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/05/22.
//

import Foundation

class Day05: Day {
    
    private let stacks = [
        ["M", "J", "C", "B", "F", "R", "L", "H"],
        ["Z", "C", "D"],
        ["H", "J", "F", "C", "N", "G", "W"],
        ["P", "J", "D", "M", "T", "S", "B"],
        ["N", "C", "D", "R", "J"],
        ["W", "L", "D", "Q", "P", "J", "G", "Z"],
        ["P", "Z", "T", "F", "R", "H"],
        ["L", "V", "M", "G"],
        ["C", "B", "G", "P", "F", "Q", "R", "J"]
    ]
    
    private lazy var procedure: [(move: Int, from: Int, to: Int)] = input.lines().compactMap {
        guard $0.hasPrefix("move") else { return nil }
        let comps = $0.components(separatedBy: .whitespaces)
        guard comps.count == 6, let move = Int(comps[1]), let from = Int(comps[3]), let to = Int(comps[5]) else { return nil }
        return (move: move, from: from, to: to)
    }
    
    func part1() -> String {
        var stax = stacks
        for step in procedure {
            (1...step.move).forEach { _ in
                let crate = stax[step.from - 1].popLast()!
                stax[step.to - 1].append(crate)
            }
        }
        return stax.reduce("") { pr, stack in pr + stack.last! }
    }
    
    func part2() -> String {
        var stax = stacks
        for step in procedure {
            var crates: [String] = []
            (1...step.move).forEach { _ in
                crates.append(stax[step.from - 1].popLast()!)
            }
            stax[step.to - 1].append(contentsOf: crates.reversed())
        }
        return stax.reduce("") { pr, stack in pr + stack.last! }
    }
    
}

