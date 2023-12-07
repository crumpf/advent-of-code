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
        "\(totalWinningsWithJokers())"
    }

    struct Hand: Comparable {
        let cards: [Character]
        let bid: Int
        let type: HandType
        let strengths: [Int]
        let useJokers: Bool

        init(cards: [Character], bid: Int, useJokers: Bool = false) {
            self.cards = cards
            self.bid = bid
            self.useJokers = useJokers
            self.strengths = cards.map { Hand.strengthOfCard($0, useJokers: useJokers) }
            self.type = Self.handType(cards: cards, useJokers: useJokers)
        }

        enum HandType: Int, CaseIterable {
            case highCard, onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, fiveOfAKind
        }

        static func strengthOfCard(_ card: Character, useJokers: Bool) -> Int {
            switch card {
            case "A": return 14
            case "K": return 13
            case "Q": return 12
            case "J": return useJokers ? 1 : 11
            case "T": return 10
            default: return Int(String(card))!
            }
        }

        private static func replaceJokers(in cards: [Character]) -> [Character] {
            let mostNonJoker = cards.reduce(into: [Character:Int]()) { dict, card in
                dict[card] = (dict[card] ?? 0) + 1
            }.sorted { lhs, rhs in
                lhs.value > rhs.value
            }.first { elem in
                elem.key != "J"
            }

            return cards.map {
                if $0 == "J", let mostNonJoker {
                    return mostNonJoker.key
                }
                return $0
            }
        }

        private static func handType(cards: [Character], useJokers: Bool) -> HandType {
            guard cards.count == 5 else { abort() }

            let dict = (!useJokers ? cards : replaceJokers(in: cards))
                .reduce(into: [Character:Int]()) { dict, card in
                    dict[card] = (dict[card] ?? 0) + 1
                }
            let orderedCounts = dict.sorted { lhs, rhs in
                lhs.value > rhs.value
            }
            let mostOccurances = orderedCounts[0].value
            let secondMostOccurances = orderedCounts.count > 1 ? orderedCounts[1].value : 0
            
            switch (mostOccurances, secondMostOccurances) {
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

    private func makeHands(input: String, useJokers: Bool = false) -> [Hand] {
        input.lines().map { line in
            let comps = line.components(separatedBy: .whitespaces)
            return Hand(cards: Array(comps[0]), bid: Int(String(comps[1]))!, useJokers: useJokers)
        }
    }

    private func totalWinnings() -> Int {
        let hands = makeHands(input: input)
        let result = hands.sorted().enumerated().reduce(0) { partialResult, elem in
            return partialResult + elem.element.bid * (elem.offset + 1)
        }
        return result
    }

    private func totalWinningsWithJokers() -> Int {
        let hands = makeHands(input: input, useJokers: true)
        let result = hands.sorted().enumerated().reduce(0) { partialResult, elem in
            return partialResult + elem.element.bid * (elem.offset + 1)
        }
        return result
    }
}
