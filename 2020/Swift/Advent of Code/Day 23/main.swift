//
//  main.swift
//  Day 23 
//
//  Created by Christopher Rumpf on 12/12/20.
//

import Foundation

//let test = Day23(input: "389125467")
//print(test.part1())
//print(test.part2())

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }
var startTime = 0.0
let day = Day23(input: fileInput.raw)

print("====Part 1====")
startTime = CFAbsoluteTimeGetCurrent()
let part1 = day.part1()
print("result: \(part1), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

print("====Part 2====")
startTime = CFAbsoluteTimeGetCurrent()
let part2 = day.part2()
print("result: \(part2), duration: \((CFAbsoluteTimeGetCurrent()-startTime)*1000)ms")

