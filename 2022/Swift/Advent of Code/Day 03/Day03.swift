//
//  Day03.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/02/22.
//

import Foundation

class Day03: Day {
    
    func part1() -> String {
        "\(sumOfPrioritiesOfItemsAppearingInBothCompartments())"
    }
    
    func part2() -> String {
        "\(sumOfPrioritiesOfItemsCorrespondingToBadgesOfEachThreeElfGroup())"
    }
    
    private func sumOfPrioritiesOfItemsAppearingInBothCompartments() -> Int {
        let repeatedItemTypes = input
            .lines()
            .compactMap {
                let mid = $0.count / 2
                let left = Set($0[0..<mid])
                let right = Set($0[mid..<$0.count])
                return left.intersection(right).first
            }
        return repeatedItemTypes.reduce(0) { partialResult, item in
            partialResult + priorityForItemType(item)
        }
    }
    
    private func sumOfPrioritiesOfItemsCorrespondingToBadgesOfEachThreeElfGroup() -> Int {
        let lines = input.lines()
        var badgeItemTypes: [Character] = []
        for i in stride(from: 0, to: lines.count, by: 3) {
            let set = Set(lines[i]).intersection(Set(lines[i+1])).intersection(Set(lines[i+2]))
            badgeItemTypes.append(set.first!)
        }
        return badgeItemTypes.reduce(0) { partialResult, item in
            partialResult + priorityForItemType(item)
        }
    }
    
    private func priorityForItemType(_ itemType: Character) -> Int {
        var priority = 0
        if itemType.isLowercase {
            priority = Int(itemType.asciiValue! - Character("a").asciiValue!) + 1
        } else {
            priority = Int(itemType.asciiValue! - Character("A").asciiValue!) + 27
        }
        return priority
    }
    
}
