//
//  Day25.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on MM/DD/YY.
//

import Foundation

class Day25: Day {
    func part1() -> String {
        calculateSNAFUNumberForBobsConsole(from: input)
    }
    
    func part2() -> String {
        "Not Implemented"
    }
    
    private let toNormalDigitMap: [Character: Int] = ["=": -2, "-": -1, "0": 0, "1": 1, "2": 2]
    private let toSNAFUDigitMap: [Int: String] =  [ 2: "2", 1: "1", 0: "0", -1: "-", -2: "=" ]
    
    private func calculateSNAFUNumberForBobsConsole(from input: String) -> String {
        let sum = input.lines().reduce(0) { accumulated, snafu in
            accumulated + normalNumber(fromSNAFU: snafu)
        }
        return snafuNumber(fromDecimal: sum)
    }
    
    private func normalNumber(fromSNAFU snafu: String) -> Int {
        snafu.reduce(0) { accumulated, snafuDigit in
            accumulated * 5 + toNormalDigitMap[snafuDigit]!
        }
    }
    
    private func snafuNumber(fromDecimal decimal: Int) -> String {
        guard decimal != 0 else {
            return toSNAFUDigitMap[decimal]!
        }
        
        let div = decimal / 5
        let modulo = decimal % 5
        if modulo < 3 {
            let moreSignificant = snafuNumber(fromDecimal: div)
            if moreSignificant == "0" {
                return toSNAFUDigitMap[modulo]!
            } else {
                return moreSignificant + toSNAFUDigitMap[modulo]!
            }
        } else {
            let moreSignificant = snafuNumber(fromDecimal: div + 1)
            if moreSignificant == "0" {
                return toSNAFUDigitMap[modulo - 5]!
            } else {
                return moreSignificant + toSNAFUDigitMap[modulo - 5]!
            }
        }
    }
}
