//
//  DayX.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on MM/DD/YY.
//

import Foundation

class Day08: Day {
    func part1() -> String {
        "\(stepsToReachZZZ())"
    }
    
    func part2() -> String {
        "Not Implemented"
    }

    struct Map {
        let instructions: [Character]
        let network: [String: (String, String)]
    }

    private func makeMap(input: String) -> Map {
        let components = input.components(separatedBy: "\n\n")
        let instructions = Array(components[0])
        let network = components[1].lines().reduce(into: [String: (String, String)]()) { dict, line in
            let node = String(line[0...2])
            let left = String(line[7...9])
            let right = String(line[12...14])
            dict[node] = (left, right)
        }
        return Map(instructions: instructions, network: network)
    }

    private func stepsToReachZZZ() -> Int {
        let map = makeMap(input: input)
        
        var node = "AAA"
        var steps = 0
        while node != "ZZZ" {
            let inst = map.instructions[steps % map.instructions.count]
            let choices = map.network[node]!
            node = inst == "L" ? choices.0 : choices.1
            steps += 1
        }

        return steps
    }
}
