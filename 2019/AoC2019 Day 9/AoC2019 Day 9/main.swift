//
//  main.swift
//  AoC2019 Day 9
//
//  Created by Chris Rumpf on 12/25/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

import Foundation

// https://adventofcode.com/2019/day/5

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

let input = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }

print(input)
