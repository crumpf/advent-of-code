//
//  Day03.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/02/22.
//

import Foundation

class Day03: Day {
    func part1() -> String {
        let repeatedItemTypes = input
            .lines()
            .compactMap {
                let mid = $0.count / 2
                let left = Set($0[0..<mid])
                let right = Set($0[mid..<$0.count])
                return left.intersection(right).first
            }
        let result = sumOfPrioritiesOfItemTypes(repeatedItemTypes)
        return "\(result)"
    }
    
    func part2() -> String {
        let lines = input.lines()
        var badgeItemTypes: [Character] = []
        for i in stride(from: 0, to: lines.count, by: 3) {
            let set = Set(lines[i]).intersection(Set(lines[i+1])).intersection(Set(lines[i+2]))
            badgeItemTypes.append(set.first!)
        }
        let result = sumOfPrioritiesOfItemTypes(badgeItemTypes)
        return "\(result)"
    }
    
    private func sumOfPrioritiesOfItemTypes(_ itemTypes: [Character]) -> Int {
        itemTypes.reduce(0) { partialResult, item in
            var priority = 0
            if item.isLowercase {
                priority = Int(item.asciiValue! - Character("a").asciiValue!) + 1
            } else {
                priority = Int(item.asciiValue! - Character("A").asciiValue!) + 27
            }
            return partialResult + priority
        }
    }
    
}

