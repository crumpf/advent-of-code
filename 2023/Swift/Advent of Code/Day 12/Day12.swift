//
//  Day12.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/12/23.
//
//  --- Day 12: Hot Springs ---

import Foundation

class Day12: Day {
    func part1() -> String {
        let records = makeRecords(input: input)
        return "\(records.map({$0.validArrangements()}).reduce(0, +))"
    }
    
    func part2() -> String {
        "Not Implemented"
    }

    struct ConditionRecord {
        let springs: [Character]
        let sizes: [Int]

        init(input: String) {
            let comps = input.components(separatedBy: .whitespaces)
            springs = Array(comps[0])
            sizes = comps[1].components(separatedBy: ",").compactMap { Int(String($0)) }
        }

        func validArrangements() -> Int {
            possibilities(of: springs).filter { possible in
                let parts = possible.split(separator: ".", omittingEmptySubsequences: true)
                guard parts.count == sizes.count,
                      zip(parts, sizes).allSatisfy({ $0.0.count == $0.1 })
                else { return false }
                return true
            }
            .count
        }

        func possibilities(of list: [Character]) -> [[Character]] {
            guard let i = list.firstIndex(where: { $0 == "?" }) else { return [list] }
            var option1 = list, option2 = list
            option1[i] = "#"
            option2[i] = "."
            return possibilities(of: option1) + possibilities(of: option2)
        }
    }

    private func makeRecords(input: String) -> [ConditionRecord] {
        input.lines().map(ConditionRecord.init(input:))
    }
}
