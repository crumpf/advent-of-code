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

func test1() -> Bool {
    let testInput = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
    let computer = IntcodeComputer(program: testInput)
    computer.run(input: [])
    return testInput == computer.output
}

print("test1 \(test1() ? "passed" : "failed")")

func test2() -> Bool {
    let testInput = [1102,34915192,34915192,7,4,7,99,0]
    let computer = IntcodeComputer(program: testInput)
    computer.run(input: [])
    guard let output = computer.output.last else {
        return false
    }
    return String(output).count == 16
}

print("test2 \(test2() ? "passed" : "failed")")

func test3() -> Bool {
    let testInput = [104,1125899906842624,99]
    let computer = IntcodeComputer(program: testInput)
    computer.run(input: [])
    guard let output = computer.output.last else {
        return false
    }
    return output == testInput[1]
}

print("test3 \(test3() ? "passed" : "failed")")


let computer = IntcodeComputer(program: input)
computer.run(input: [1])
print("BOOST output:\n\(computer.output)")
