//
//  Day10.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/10/22.
//

import Foundation

class Day10: Day {
    
    func part1() -> String {
        "\(sumOfSignalStrengthsDuringCycles([20, 60, 100, 140, 180, 220]))"
    }
    
    func part2() -> String {
        imageRenderedOnCRT()
    }
    
    private func sumOfSignalStrengthsDuringCycles(_ cycles: [Int]) -> Int {
        var sortedCycles = cycles.sorted(by: <)
        var strengths: [Int] = []
        let cpu = CPU(program: input)
        let cancellable = cpu.$cycle.sink { cycle in
            if let first = sortedCycles.first, first == cycle {
                strengths.append(cycle * cpu.X)
                sortedCycles.removeFirst()
            }
        }
        cpu.run()
        return strengths.reduce(0, +)
    }
    
    private func imageRenderedOnCRT() -> String {
        let rowLength = 40
        var crt: [[Character]] = Array(repeating: Array(repeating: Character("."), count: rowLength), count: 6)
        let cpu = CPU(program: input)
        let cancellable = cpu.$cycle.sink { cycle in
            guard cycle > 0 else { return }
            let pixel = (cycle - 1) % rowLength
            let sprite = (cpu.X-1)...(cpu.X+1)
            if sprite.contains(pixel) {
                crt[(cycle - 1)/rowLength][pixel] = "#"
            }
        }
        cpu.run()
        return crt.map { String($0) }.joined(separator: "\n")
    }
    
    class CPU {
        enum Instruction {
            case noop
            case addx(Int)
        }
        
        @Published private(set) var cycle = 0
        private(set) var X = 1
        private let program: String
        
        init(program: String) {
            self.program = program
        }
                
        func run() {
            program.enumerateLines { line, stop in
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
                    self.cycle += 1
                }
                
                // finish execution
                if let currentinstruction {
                    switch currentinstruction {
                    case .noop:
                        break
                    case .addx(let value):
                        self.X += value
                    }
                }
            }
        }
    }
    
}
