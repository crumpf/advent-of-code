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
        "\(sumOfAllCalibrationValues() ?? 0)"
    }
    
    func part2() -> String {
        "Not Implemented"
    }
    
    private func sumOfAllCalibrationValues() -> Int? {
        input.lines().compactMap(calibrationValue(of:)).reduce(0, +)
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
    
}
