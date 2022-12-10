//
//  Day10.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/10/22.
//

import Foundation

class Day10: Day {
    
    func part1() -> String {
        "\(sumOfSignalStrengthsDuringCycles([20, 60, 100, 140, 180, 220], program: input))"
    }
    
    func part2() -> String {
        "Not Implemented"
    }
    
    enum Instruction {
        case noop
        case addx(Int)
    }
    
    private func sumOfSignalStrengthsDuringCycles(_ cycles: [Int], program: String) -> Int {
        guard !cycles.isEmpty else { return 0 }
        var sortedCycles = cycles.sorted(by: <)
        var x = 1
        var cycle = 0
        var strengths: [Int] = []
        var target = sortedCycles.removeFirst()
        
        input.enumerateLines { line, stop in
            var duration = 1
            var currentinstruction: Instruction?
            let comps = line.components(separatedBy: .whitespaces)
            switch comps[0] {
            case "noop":
                currentinstruction = .noop
                duration = 1
            case "addx" where comps.count == 2:
                currentinstruction = .addx(Int(comps[1])!)
                duration = 2
            default:
                break
            }
            
            // run cycles
            for _ in 1...duration {
                cycle += 1
                if target == cycle {
                    strengths.append(target * x)
                    if !sortedCycles.isEmpty {
                        target = sortedCycles.removeFirst()
                    } else {
                        stop = true
                    }
                }
            }
            
            // finish execution
            if let currentinstruction {
                switch currentinstruction {
                case .noop:
                    break
                case .addx(let value):
                    x += value
                }
            }
        }
        
        return strengths.reduce(0, +)
    }
    
}
