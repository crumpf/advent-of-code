//
//  Day10.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/10/22.
//

import Foundation
import Combine

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
        var bag = Set<AnyCancellable>()
        cpu.cycleStartedPublisher.sink { cycle in
            if let first = sortedCycles.first, first == cycle {
                strengths.append(cycle * cpu.X)
                sortedCycles.removeFirst()
            }
        }.store(in: &bag)
        cpu.run()
        return strengths.reduce(0, +)
    }
    
    private func imageRenderedOnCRT() -> String {
        let rowLength = 40
        var crt: [[Character]] = Array(repeating: Array(repeating: Character("."), count: rowLength), count: 6)
        let cpu = CPU(program: input)
        var bag = Set<AnyCancellable>()
        cpu.cycleStartedPublisher.sink { cycle in
            guard cycle > 0 else { return }
            let pixel = (cycle - 1) % rowLength
            let sprite = (cpu.X-1)...(cpu.X+1)
            if sprite.contains(pixel) {
                crt[(cycle - 1)/rowLength][pixel] = "#"
            }
        }.store(in: &bag)
        cpu.run()
        return crt.map { String($0) }.joined(separator: "\n")
    }
    
    class CPU {
        private(set) var cycle = 0
        private(set) var X = 1
        var cycleStartedPublisher: some Publisher<Int, Never> { cycleStarted }
        var cycleEndedPublisher: some Publisher<Int, Never> { cycleEnded }
        
        private let cycleStarted = PassthroughSubject<Int, Never>()
        private let cycleEnded = PassthroughSubject<Int, Never>()
        private let program: String
        
        init(program: String) {
            self.program = program
        }
                
        func run() {
            program.enumerateLines { line, stop in
                let comps = line.components(separatedBy: .whitespaces)
                switch comps[0] {
                case "noop":
                    self.tick()
                case "addx" where comps.count == 2:
                    self.tick()
                    self.tick { self.X += Int(comps[1])! }
                default:
                    print("Invalid instruction: \(comps)")
                    stop = true
                    return
                }
            }
        }
        
        private func tick(operation: (() -> Void)? = nil) {
            cycle += 1
            cycleStarted.send(cycle)
            operation?()
            cycleEnded.send(cycle)
        }
    }
    
}
