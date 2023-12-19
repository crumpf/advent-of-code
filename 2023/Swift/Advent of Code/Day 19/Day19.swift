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
            let regex = Regex {
                Capture { OneOrMore(.word) }
                "{"
                Capture { OneOrMore(.any) }
                "}"
            }
            let lessThanRegex = Regex {
                Capture { OneOrMore(.word) }
                "<"
                Capture { OneOrMore(.digit) }
                ":"
                Capture { OneOrMore(.word) }
            }
            let moreThanRegex = Regex {
                Capture { OneOrMore(.word) }
                ">"
                Capture { OneOrMore(.digit) }
                ":"
                Capture { OneOrMore(.word) }
            }

            var workflowsCache: [String: [Rule]] = [:]
            let parts = input.components(separatedBy: "\n\n")
            parts[0].enumerateLines { line, stop in
                if let match = line.matches(of: regex).first {
                    let (_, name, rules) = match.output
                    workflowsCache[String(name)] = rules.components(separatedBy: ",").map { rule in
                        if let m = rule.matches(of: lessThanRegex).first {
                            let (_, lhs, rhs, res) = m.output
                            return Rule(lhs: String(lhs), op: "<", rhs: Int(rhs), result: String(res))
                        } else if let m = rule.matches(of: moreThanRegex).first {
                            let (_, lhs, rhs, res) = m.output
                            return Rule(lhs: String(lhs), op: ">", rhs: Int(rhs), result: String(res))
                        } else {
                            return Rule(lhs: nil, op: nil, rhs: nil, result: rule)
                        }
                    }

                }
            }
            workflows = workflowsCache

            var ratingsCache: [[String: Int]] = []
            parts[1].enumerateLines { line, stop in
                let dict = line.dropFirst().dropLast()
                    .components(separatedBy: ",")
                    .reduce(into: [String: Int]()) { partialResult, partRating in
                        let comps = partRating.components(separatedBy: "=")
                        partialResult[comps[0]] = Int(comps[1])
                    }
                ratingsCache.append(dict)
            }
            partRatings = ratingsCache
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

        struct Rule {
            let lhs: String?
            let op: String?
            let rhs: Int?
            let result: String
        }
    }
}
