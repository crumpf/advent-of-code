//
//  main.swift
//  Day 10
//
//  Created by Christopher Rumpf on 12/10/20.
//

import Foundation

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }
let day = Day10(input: fileInput.raw)

print("====Part 1====")
print(day.part1())

print("====Part 2====")
print(day.part2())

