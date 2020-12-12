//
//  main.swift
//  Day 1
//
//  Created by Christopher Rumpf on 12/1/20.
//

import Foundation

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }
let day = Day1(input: fileInput.raw)

print("====Part 1====")
print(day.part1())

print("====Part 2====")
print(day.part2())
