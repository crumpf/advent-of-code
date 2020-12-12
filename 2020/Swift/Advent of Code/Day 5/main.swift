//
//  main.swift
//  Day 5
//
//  Created by Christopher Rumpf on 12/5/20.
//

import Foundation

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }
let day = Day5(input: fileInput.raw)

print("====Part 1====")
print(day.part1())

print("====Part 2====")
print(day.part2())

let redux = Day5Redux(input: fileInput.raw)

print("====Part 1 Redux====")
print(redux.part1())

print("====Part 2 Redux====")
print(redux.part2())
