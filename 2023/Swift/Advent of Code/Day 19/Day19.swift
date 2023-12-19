//
//  Day19.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/19/23.
//

import Foundation
import RegexBuilder

class Day19: Day {
    func part1() -> String {
        let puzzle = Puzzle(input: input)
        return "\(puzzle.sumOfRatingNumbersForAcceptedParts())"
    }
    
    func part2() -> String {
        "Not Implemented"
    }

    struct Puzzle {
        let workflows: [String: [Rule]]
        let partRatings: [[String: Int]]

        init(input: String) {
            let parts = input.components(separatedBy: "\n\n")
            workflows = Self.makeWorkflows(lines: parts[0].lines())
            partRatings = Self.makePartRatings(lines: parts[1].lines())
        }

        func sumOfRatingNumbersForAcceptedParts() -> Int {
            partRatings.reduce(0) { partialResult, ratings in
                partialResult + (isAccepted(ratings: ratings, workflowName: "in") ? ratings.values.reduce(0, +) : 0)
            }
        }

        private func isAccepted(ratings: [String: Int], workflowName: String) -> Bool {
            guard let rules = workflows[workflowName] else { return false }
            for rule in rules {
                if rule.op == "<" && ratings[rule.lhs!]! >= rule.rhs! ||
                    rule.op == ">" && ratings[rule.lhs!]! <= rule.rhs! {
                    continue
                }
                switch rule.result {
                case "A": return true
                case "R": return false
                default: return isAccepted(ratings: ratings, workflowName: rule.result)
                }
            }
            return false
        }

        private static func makeWorkflows(lines: [String]) -> [String: [Rule]] {
            let rulesRegex = Regex {
                Capture { OneOrMore(.word) }
                "{"
                Capture { OneOrMore(.any) }
                "}"
            }
            let comparisonRegex = Regex {
                Capture { One(.anyOf("xmas")) }
                Capture { One(.anyOf("<>")) }
                Capture { OneOrMore(.digit) }
                ":"
                Capture { OneOrMore(.word) }
            }

            var workflowsCache: [String: [Rule]] = [:]
            for line in lines {
                if let match = line.matches(of: rulesRegex).first {
                    let (_, name, rules) = match.output
                    workflowsCache[String(name)] = rules.components(separatedBy: ",").map { rule in
                        if let m = rule.matches(of: comparisonRegex).first {
                            let (_, lhs, op, rhs, res) = m.output
                            return Rule(lhs: String(lhs), op: String(op), rhs: Int(rhs), result: String(res))
                        } else {
                            return Rule(lhs: nil, op: nil, rhs: nil, result: rule)
                        }
                    }
                }
            }
            return workflowsCache
        }

        private static func makePartRatings(lines: [String]) -> [[String: Int]] {
            var ratingsCache: [[String: Int]] = []
            for line in lines {
                let dict = line.dropFirst().dropLast()
                    .components(separatedBy: ",")
                    .reduce(into: [String: Int]()) { partialResult, partRating in
                        let comps = partRating.components(separatedBy: "=")
                        partialResult[comps[0]] = Int(comps[1])
                    }
                ratingsCache.append(dict)
            }
            return ratingsCache
        }

        struct Rule {
            let lhs: String?
            let op: String?
            let rhs: Int?
            let result: String
        }
    }
}
