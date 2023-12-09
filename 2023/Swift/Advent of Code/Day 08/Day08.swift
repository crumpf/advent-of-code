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
        "\(stepsToReachNodesEndingInZ())"
    }

    struct Map {
        let instructions: [Character]
        let network: [String: (String, String)]

        func stepsToReachGoal(start: String, goal: (String) -> Bool) -> Int {
            var node = start
            var steps = 0
            while !goal(node) {
                let inst = instructions[steps % instructions.count]
                let choices = network[node]!
                node = inst == "L" ? choices.0 : choices.1
                steps += 1
            }
            return steps
        }
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
        let steps = map.stepsToReachGoal(start: "AAA") { node in
            node == "ZZZ"
        }
        return steps
    }

    private func stepsToReachNodesEndingInZ() -> Int {
        let map = makeMap(input: input)
        let startNodes = map.network.keys.filter { $0.last == "A" }
        let loopSteps = startNodes.map { start in
            map.stepsToReachGoal(start: start) { node in
                node.last == "Z"
            }
        }
        return loopSteps.reduce(1) { Math.lcm($0, $1) }
    }

}
