//
//  main.swift
//  Day 16
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }
var startTime = 0.0
let day = Day16(input: fileInput.raw)

print("====Part 1====")
startTime = CFAbsoluteTimeGetCurrent()
let part1 = day.part1()
print("result: \(part1), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

print("====Part 2====")
startTime = CFAbsoluteTimeGetCurrent()
let part2 = day.part2()
print("result: \(part2), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

