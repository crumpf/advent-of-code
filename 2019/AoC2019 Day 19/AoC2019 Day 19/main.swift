//
//  main.swift
//  AoC2019 Day 19
//
//  Created by Chris Rumpf on 1/9/20.
//  Copyright © 2020 Chris Rumpf. All rights reserved.
//

import Foundation

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

// --- Day 19: Tractor Beam ---

