//
//  DayX.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on MM/DD/YY.
//
//  --- Day 6: Wait For It ---


import Foundation

class Day06: Day {
    func part1() -> String {
        "\(productOfNumberOfWaysToBeatRecord())"
    }
    
    func part2() -> String {
        "Not Implemented"
    }
    
    func productOfNumberOfWaysToBeatRecord() -> Int {
        let records = Records(input: input)
        let winners = zip(records.time, records.distance).compactMap { (time, dist) in
            var numWaysToWin = 0
            let half = time / 2
            for t in (0..<half).reversed() {
                if raceResult(lasts: time, holdTime: t) > dist {
                    numWaysToWin += 1
                } else {
                    break
                }
            }
            for t in (half...time) {
                if raceResult(lasts: time, holdTime: t) > dist {
                    numWaysToWin += 1
                } else {
                    break
                }
            }
            return numWaysToWin > 0 ? numWaysToWin : nil
        }
        return winners.reduce(1, *)
    }
    
    private func raceResult(lasts: Int, holdTime: Int) -> Int {
        (lasts - holdTime) * holdTime
    }
    
    struct Records {
        let time, distance: [Int]
        
        init(input: String) {
            let mapped = input.lines().map { line in
                line.components(separatedBy: .whitespaces).dropFirst().compactMap(Int.init)
            }
            time = mapped[0]
            distance = mapped[1]
        }
    }
    
}
