//
//  main.swift
//  Day 09
//
//  Created by Christopher Rumpf.
//

import Foundation

let testInput = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }
var startTime = 0.0
//let day = Day09(input: testInput)
let day = Day09(input: fileInput.raw)

print("====Part 1====")
startTime = CFAbsoluteTimeGetCurrent()
let part1 = day.part1()
print("result: \(part1), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

print("====Part 2====")
startTime = CFAbsoluteTimeGetCurrent()
let part2 = day.part2()
print("result: \(part2), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

