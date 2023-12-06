//
//  Day01.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/03/2023.
//
//  --- Day 1: Trebuchet?! ---


import Foundation

class Day01: Day {
    func part1() -> String {
        "\(sumOfAllCalibrationValues(of: input.lines()) ?? 0)"
    }
    
    func part2() -> String {
        "\(sumOfAllCalibrationValuesWithSpelledOutLetters(of: input.lines()) ?? 0)"
    }
    
    private func sumOfAllCalibrationValues(of lines: [String]) -> Int? {
        lines.compactMap(calibrationValue(of:)).reduce(0, +)
    }
    
    private func calibrationValue(of line: String) -> Int? {
        // On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.
        guard let first = line.first(where: { $0.isNumber && $0.isASCII }),
              let tens = Int(String(first)),
              let last = line.last(where: { $0.isNumber && $0.isASCII }),
              let ones = Int(String(last))
        else {
            return nil
        }
        
        return tens * 10 + ones
    }
    
    private let spelledToDigitMap = [
        "zero": "0",
        "one": "1",
        "two": "2",
        "three": "3",
        "four": "4",
        "five": "5",
        "six": "6",
        "seven": "7",
        "eight": "8",
        "nine": "9"
    ]
    
    private func sumOfAllCalibrationValuesWithSpelledOutLetters(of lines: [String]) -> Int? {
        let conversions = lines.map(convertSpelled(_:))
        let values = conversions.compactMap(calibrationValue(of:))
        return sumOfAllCalibrationValues(of: lines.map(convertSpelled(_:)))
    }

    private func convertSpelled(_ line: String) -> String {
        convertLast(convertFirst(line))
    }
        
    private func convertFirst(_ line: String) -> String {
        for start in (0..<line.count) {
            for (spelled, number) in spelledToDigitMap {
                // (╯°□°）╯︵ ┻━┻  there are cases in the actual input where 2 spelled numbers overlap and
                // should both be decoded. For example, "nineight" should be "98". So replacing the whole
                // range we find can give incorrect results as I did first in this commented code. Gah!
//                if line[start..<line.count].hasPrefix(spelled),
//                   let range = line.range(of: spelled) {
//                    return line.replacingCharacters(in: range, with: number)
//                }
                
                // instead, just replace the starting character
                if line[start..<line.count].hasPrefix(spelled) {
                    let index = line.index(line.startIndex, offsetBy: start)
                    return line.replacingCharacters(in: index...index, with: number)
                }
            }
        }
        return line
    }
    
    private func convertLast(_ line: String) -> String {
        for last in (0..<line.count).reversed() {
            for (spelled, number) in spelledToDigitMap {
//                if line[0...last].hasSuffix(spelled),
//                   let range = line.range(of: spelled, options: [.backwards]) {
//                    return line.replacingCharacters(in: range, with: number)
//                }
                if line[0...last].hasSuffix(spelled) {
                    let index = line.index(line.startIndex, offsetBy: last)
                    return line.replacingCharacters(in: index...index, with: number)
                }
            }
        }
        return line
    }
    
}
