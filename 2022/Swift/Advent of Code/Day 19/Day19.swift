//
//  Day19.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/19/22.
//

import Foundation
import RegexBuilder

class Day19: Day {
    func part1() -> String {
        "\(sumOfQualityLevelsOfAllBlueprints(timeLimitMinutes: 24))"
    }
    
    func part2() -> String {
        "Not Implemented"
    }
    
    private func sumOfQualityLevelsOfAllBlueprints(timeLimitMinutes: Int) -> Int {
        print(makeBlueprints().count)
        return 33
    }
    
    private func makeBlueprints() -> [Blueprint] {
        //Blueprint 1: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 17 clay. Each geode robot costs 3 ore and 11 obsidian.
         let numberCapture = Capture {
             OneOrMore(.digit)
         }
         let regex = Regex {
             "Blueprint "
             numberCapture
             ": Each ore robot costs "
             numberCapture
             " ore. Each clay robot costs "
             numberCapture
             " ore. Each obsidian robot costs "
             numberCapture
             " ore and "
             numberCapture
             " clay. Each geode robot costs "
             numberCapture
             " ore and "
             numberCapture
             " obsidian."
         }
        var blueprints = [Blueprint]()
        input.enumerateLines { line, stop in
            for match in line.matches(of: regex).enumerated() {
                let (_, blueprintNum, oreBotOreCost, clayBotOreCost, obsidianBotOreCost, obsidianBotClayCost, geodeBotOreCost, geodeBotObsidianCost) = match.element.output
                blueprints.append(
                    Blueprint(
                        number: Int(blueprintNum)!,
                        oreBot: Bot(cost: Cost(ore: Int(oreBotOreCost)!, clay: 0, obsidian: 0)),
                        clayBot: Bot(cost: Cost(ore: Int(clayBotOreCost)!, clay: 0, obsidian: 0)),
                        obsidianBot: Bot(cost: Cost(ore: Int(obsidianBotOreCost)!, clay: Int(obsidianBotClayCost)!, obsidian: 0)),
                        geodeBot: Bot(cost: Cost(ore: Int(geodeBotOreCost)!, clay: 0, obsidian: Int(geodeBotObsidianCost)!))
                    )
                )
            }
        }
        return blueprints
    }
    
    struct Cost {
        let ore: Int
        let clay: Int
        let obsidian: Int
    }
    
    struct Bot {
        let cost: Cost
    }
    
    struct Blueprint {
        let number: Int
        let oreBot: Bot
        let clayBot: Bot
        let obsidianBot: Bot
        let geodeBot: Bot
    }
}
