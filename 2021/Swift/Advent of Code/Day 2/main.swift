//
//  main.swift
//  Day 2
//
//  Created by Christopher Rumpf on 12/2/20.
//

import Foundation

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }
let day = Day2(input: fileInput.raw)
var startTime = 0.0

print("====Part 1====")
startTime = CFAbsoluteTimeGetCurrent()
print("result: \(day.part1()), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

print("====Part 2====")
startTime = CFAbsoluteTimeGetCurrent()
print("result: \(day.part2()), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")
