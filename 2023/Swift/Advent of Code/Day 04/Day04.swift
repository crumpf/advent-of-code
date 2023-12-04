//
//  DayX.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on MM/DD/YY.
//

import Foundation

class Day04: Day {
    func part1() -> String {
        "\(sumOfCardPoints())"
    }
    
    func part2() -> String {
        "\(totalCards())"
    }
    
    private func sumOfCardPoints() -> Int {
        input.lines()
            .map(makeCard(line:))
            .map { card in
                let myWinners = Set(card.winners).intersection(Set(card.have))
                if myWinners.count > 0 {
                    return 1 << (myWinners.count - 1)
                }
                return 0
            }
            .reduce(0, +)
    }
    
    private func totalCards() -> Int {
        var instances = Array(repeating: 1, count: input.lines().count)
        let cards = input.lines().map(makeCard(line:))
        for (index, card) in cards.enumerated() {
            let myWinners = Set(card.winners).intersection(Set(card.have))
            if myWinners.count > 0 {
                for offset in 1...myWinners.count {
                    let next = index + offset
                    if offset < instances.count {
                        instances[next] += instances[index]
                    }
                }
            }
        }
        return instances.reduce(0, +)
    }
    
    struct Card {
        let id: Int
        let winners: [Int]
        let have: [Int]
    }
    
    private func makeCard(line: String) -> Card {
        // e.g. "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
        let comps = line.components(separatedBy: ":")
        let id = Int(comps[0].dropFirst("Card".count).trimmingCharacters(in: .whitespaces))!
        let nums = comps[1].components(separatedBy: "|").map {
            $0.trimmingCharacters(in: .whitespaces)
                .components(separatedBy: .whitespaces)
                .compactMap {
                    Int($0)
                }
        }
        return Card(id: id, winners: nums[0], have: nums[1])
    }
    
}
