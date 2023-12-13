//
//  main.swift
//  Day 13
//
//  Created by Christopher Rumpf.
//

import Foundation

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "inputs/day/13/input") else { abort() }
//guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "inputs/day/13/example") else { abort() }
var startTime = 0.0
let day = Day13(input: fileInput.raw)

print("====Part 1====")
startTime = CFAbsoluteTimeGetCurrent()
let part1 = day.part1()
print("result: \(part1), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

print("====Part 2====")
startTime = CFAbsoluteTimeGetCurrent()
let part2 = day.part2()
print("result: \(part2), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

