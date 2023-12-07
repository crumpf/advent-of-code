//
//  Day07.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/07/2023.
//

import Foundation

class Day07: Day {
    func part1() -> String {
        "\(totalWinnings())"
    }
    
    func part2() -> String {
        "Not Implemented"
    }

    struct Hand: Comparable {
        let cards: [Character]
        let bid: Int
        let type: HandType
        let strengths: [Int]

        init(cards: [Character], bid: Int) {
            self.cards = cards
            self.bid = bid
            self.strengths = cards.map(Hand.strengthOfCard(_:))
            self.type = Self.handType(cards: cards)
        }

        enum HandType: Int, CaseIterable {
            case highCard
            case onePair
            case twoPair
            case threeOfAKind
            case fullHouse
            case fourOfAKind
            case fiveOfAKind
        }

        static func strengthOfCard(_ card: Character) -> Int {
            switch card {
            case "A": return 14
            case "K": return 13
            case "Q": return 12
            case "J": return 11
            case "T": return 10
            default: return Int(String(card))!
            }
        }

        private static func handType(cards: [Character]) -> HandType {
            guard cards.count == 5 else { abort() }

            let orderedCounts = cards.reduce(into: [Character:Int]()) { dict, card in
                dict[card] = (dict[card] ?? 0) + 1
            }
                .sorted { lhs, rhs in
                    lhs.value > rhs.value
                }

            switch (orderedCounts[0].value, orderedCounts.count > 1 ? orderedCounts[1].value : 0) {
            case (5, _): return .fiveOfAKind
            case (4, _): return .fourOfAKind
            case (3, 2): return .fullHouse
            case (3, _): return .threeOfAKind
            case (2, 2): return .twoPair
            case (2, _): return .onePair
            default: return .highCard
            }
        }

        static func < (lhs: Hand, rhs: Hand) -> Bool {
            if lhs.type.rawValue != rhs.type.rawValue {
                return lhs.type.rawValue < rhs.type.rawValue
            }

            for pair in zip(lhs.strengths, rhs.strengths) {
                if pair.0 != pair.1 {
                    return pair.0 < pair.1
                }
            }

            return true
        }
    }

    private func makeHands(input: String) -> [Hand] {
        input.lines().map { line in
            let comps = line.components(separatedBy: .whitespaces)
            return Hand(cards: Array(comps[0]), bid: Int(String(comps[1]))!)
        }
    }

    private func totalWinnings() -> Int {
        let hands = makeHands(input: input)
        let result = hands.sorted().enumerated().reduce(0) { partialResult, elem in
            return partialResult + elem.element.bid * (elem.offset + 1)
        }
        return result
    }
}
