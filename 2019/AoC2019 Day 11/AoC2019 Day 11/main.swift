//
//  main.swift
//  AoC2019 Day 11
//
//  Created by Chris Rumpf on 12/27/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

import Foundation

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

let input = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }

print(input)
