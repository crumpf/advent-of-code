//
//  Day11.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/22.
//

import Foundation

class Day11: Day {
    func part1() -> String {
        "\(levelOfMonkeyBusiness(rounds: 20, relievedAfterInspection: true))"
    }
    
    func part2() -> String {
        "\(levelOfMonkeyBusiness(rounds: 10_000, relievedAfterInspection: false))"
    }
    
    enum Operation {
        case multiply(Int)
        case add(Int)
        case square
    }
    
    struct Test {
        let divisibleBy: Int
        let trueMonkey: Int
        let falseMonkey: Int
    }
    
    class Monkey {
        var items: [Int]
        let operation: Operation
        let test: Test
        var inspectionCount = 0
        
        init(items: [Int], operation: Operation, test: Test) {
            self.items = items
            self.operation = operation
            self.test = test
        }
    }
    
    private func makeMonkeys() -> [Monkey] {
        input.components(separatedBy: "\n\n").map { monkeyNotes in
            let comps = monkeyNotes.components(separatedBy: .newlines)
            let items = comps[1].split(separator: ": ")[1].split(separator: ", ").compactMap { Int($0) }
            let op: Operation
            if let operand = Int(comps[2].components(separatedBy: .whitespaces).last!) {
                op = comps[2].firstIndex(of: "*") != nil  ? Operation.multiply(operand) : Operation.add(operand)
            } else {
                op = Operation.square
            }
            let test = Test(divisibleBy: Int(comps[3].components(separatedBy: .whitespaces).last!)!,
                            trueMonkey:  Int(comps[4].components(separatedBy: .whitespaces).last!)!,
                            falseMonkey: Int(comps[5].components(separatedBy: .whitespaces).last!)!)
            return Monkey(items: items, operation: op, test: test)
        }
    }
    
    private func levelOfMonkeyBusiness(rounds: Int, relievedAfterInspection: Bool) -> Int {
        let monkeys = makeMonkeys()
        let productOfAllMonkeyTests = monkeys.reduce(1) { $0 * $1.test.divisibleBy }
        for _ in 1...rounds {
            for monkey in monkeys {
                while !monkey.items.isEmpty {
                    let item = monkey.items.removeFirst()
                    monkey.inspectionCount += 1
                    var worry = 0
                    switch monkey.operation {
                    case .multiply(let operand):
                        worry = item * operand
                    case .add(let operand):
                        worry = item + operand
                    case .square:
                        worry = item * item
                    }
                    worry = relievedAfterInspection ? worry / 3 : worry % productOfAllMonkeyTests
                    if worry.isMultiple(of: monkey.test.divisibleBy) {
                        monkeys[monkey.test.trueMonkey].items.append(worry)
                    } else {
                        monkeys[monkey.test.falseMonkey].items.append(worry)
                    }
                }
            }
        }
        return monkeys.map { $0.inspectionCount }.sorted(by: >)[0..<2].reduce(1, *)
    }
    
}
