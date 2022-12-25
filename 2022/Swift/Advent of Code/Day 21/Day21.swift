//
//  Day21.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/23/22.
//

import Foundation

class Day21: Day {
    func part1() -> String {
        "\(numberYelledByRootMonkey())"
    }
    
    func part2() -> String {
        "\(numberYouYellToPassRootEqualityTest())"
        return "Not Implemented"
    }
    
    private func numberYelledByRootMonkey() -> Int {
        var (numberYelledByMonkey, equations) = parse(input)
        while !equations.isEmpty {
            for (key, value) in equations {
                if let l = numberYelledByMonkey[value.left], let r = numberYelledByMonkey[value.right] {
                    let result: Int
                    switch value.operation {
                    case .add:
                        result = l + r
                    case .subtract:
                        result = l - r
                    case .multiply:
                        result = l * r
                    case .divide:
                        result = l / r
                    }
                    numberYelledByMonkey[key] = result
                    equations[key] = nil
                }
            }
        }
        return numberYelledByMonkey["root"] ?? 0
    }
    
    private func numberYouYellToPassRootEqualityTest() -> Int {
        return -1
    }
    
    struct Equation {
        let left: String
        let right: String
        let operation: Operation
    }
    enum Operation {
        case add, subtract, multiply, divide
    }
    
    private func parse(_ string: String) -> (numberYelledByMonkey: [String: Int], equations: [String: Equation]) {
        var numbers = [String: Int]()
        var equations = [String: Equation]()
        string.enumerateLines { line, stop in
            let split = line.split(separator: ": ")
            let monkey = String(split[0])
            if split[1].contains(" ") {
                let opSplit = split[1].split(separator: " ")
                let left = String(opSplit[0]), right = String(opSplit[2])
                switch opSplit[1] {
                case "+":
                    equations[monkey] = Equation(left: left, right: right, operation: .add)
                case "-":
                    equations[monkey] = Equation(left: left, right: right, operation: .subtract)
                case "*":
                    equations[monkey] = Equation(left: left, right: right, operation: .multiply)
                case "/":
                    equations[monkey] = Equation(left: left, right: right, operation: .divide)
                default:
                    break
                }
            } else {
                numbers[monkey] = Int(split[1])!
            }
        }
        return (numbers, equations)
    }
}
