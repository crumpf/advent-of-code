//
//  Day05.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/05/22.
//

import Foundation

class Day05: Day {
    
    private lazy var stacks: [[String]] = {
        let lines = input.lines()
        guard let dividerIndex = lines.firstIndex(of: "") else { return [] }
        
        let stackIndexLine = lines[dividerIndex-1]
        guard let last = stackIndexLine.last, let numberOfStacks = Int(String(last)) else { return [] }
        
        var stax: [[String]] = Array(repeating: [], count: numberOfStacks)
        var lineIndex = dividerIndex - 2
        while lineIndex >= 0 {
            let line = lines[lineIndex]
            var stackIndex = 0
            for n in stride(from: 1, to: line.count, by: 4) {
                let crate = line[n]
                if crate.isLetter {
                    stax[stackIndex].append(String(crate))
                }
                stackIndex += 1
            }
            lineIndex -= 1
        }
        return stax
    }()
    
    private lazy var procedure: [(move: Int, from: Int, to: Int)] = input.lines().compactMap {
        guard $0.hasPrefix("move") else { return nil }
        let comps = $0.components(separatedBy: .whitespaces)
        guard comps.count == 6, let move = Int(comps[1]), let from = Int(comps[3]), let to = Int(comps[5]) else { return nil }
        return (move: move, from: from, to: to)
    }
    
    private func cratesOnTopOfEachStackAfterRearrangmentProcedureWithCrateMover9000() -> String {
        var stax = stacks
        for step in procedure {
            (1...step.move).forEach { _ in
                let crate = stax[step.from - 1].popLast()!
                stax[step.to - 1].append(crate)
            }
        }
        return stax.reduce("") { pr, stack in pr + stack.last! }
    }
    
    private func cratesOnTopOfEachStackAfterRearrangmentProcedureWithCrateMover9001() -> String {
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
    
    func part1() -> String {
        cratesOnTopOfEachStackAfterRearrangmentProcedureWithCrateMover9000()
    }
    
    func part2() -> String {
        cratesOnTopOfEachStackAfterRearrangmentProcedureWithCrateMover9001()
    }
    
}
