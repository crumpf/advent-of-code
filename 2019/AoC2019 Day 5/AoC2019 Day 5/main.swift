//
//  main.swift
//  AoC2019 Day 5
//
//  Created by Chris Rumpf on 12/14/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

// https://adventofcode.com/2019/day/5

import Foundation

var str = "Advent of Code 2019, Day 5"
print(str)

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

let computer = IntcodeComputer()
do {
    let input = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }
    let result = try computer.process(input)
    print(result)
} catch {
    print(error.localizedDescription)
}
