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
        [
            Monkey(items: [99, 63, 76, 93, 54, 73],
                   operation: .multiply(11),
                   test: Test(divisibleBy: 2, trueMonkey: 7, falseMonkey: 1)),
            Monkey(items: [91, 60, 97, 54],
                   operation: .add(1),
                   test: Test(divisibleBy: 17, trueMonkey: 3, falseMonkey: 2)),
            Monkey(items: [65],
                   operation: .add(7),
                   test: Test(divisibleBy: 7, trueMonkey: 6, falseMonkey: 5)),
            Monkey(items: [84, 55],
                   operation: .add(3),
                   test: Test(divisibleBy: 11, trueMonkey: 2, falseMonkey: 6)),
            Monkey(items: [86, 63, 79, 54, 83],
                   operation: .square,
                   test: Test(divisibleBy: 19, trueMonkey: 7, falseMonkey: 0)),
            Monkey(items: [96, 67, 56, 95, 64, 69, 96],
                   operation: .add(4),
                   test: Test(divisibleBy: 5, trueMonkey: 4, falseMonkey: 0)),
            Monkey(items: [66, 94, 70, 93, 72, 67, 88, 51],
                   operation: .multiply(5),
                   test: Test(divisibleBy: 13, trueMonkey: 4, falseMonkey: 5)),
            Monkey(items: [59, 59, 74],
                   operation: .add(8),
                   test: Test(divisibleBy: 3, trueMonkey: 1, falseMonkey: 3))
        ]
    }
    
//    private func makeMonkeys() -> [Monkey] {
//        [
//            Monkey(items: [79, 98],
//                   operation: .multiply(19),
//                   test: Test(divisibleBy: 23, trueMonkey: 2, falseMonkey: 3)),
//            Monkey(items: [54, 65, 75, 74],
//                   operation: .add(6),
//                   test: Test(divisibleBy: 19, trueMonkey: 2, falseMonkey: 0)),
//            Monkey(items: [79, 60, 97],
//                   operation: .square,
//                   test: Test(divisibleBy: 13, trueMonkey: 1, falseMonkey: 3)),
//            Monkey(items: [74],
//                   operation: .add(3),
//                   test: Test(divisibleBy: 17, trueMonkey: 0, falseMonkey: 1))
//        ]
//    }
    
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
