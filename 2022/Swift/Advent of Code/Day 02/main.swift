//
//  main.swift
//  Day 02
//
//  Created by Christopher Rumpf.
//

import Foundation

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }
var startTime = 0.0
let day = Day02(input: fileInput.raw)

print("====Part 1====")
startTime = CFAbsoluteTimeGetCurrent()
let part1 = day.part1()
print("result: \(part1), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

print("====Part 2====")
startTime = CFAbsoluteTimeGetCurrent()
let part2 = day.part2()
print("result: \(part2), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

let dayAlt = Day02Alternative(input: fileInput.raw)

print("====Part 1 Alternative ====")
startTime = CFAbsoluteTimeGetCurrent()
let part1Alt = dayAlt.part1()
print("result: \(part1Alt), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

print("====Part 2 Alternative ====")
startTime = CFAbsoluteTimeGetCurrent()
let part2Alt = dayAlt.part2()
print("result: \(part2Alt), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")
