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

struct Point: Hashable {
    let x, y: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

enum PaintColor: Int {
    case black = 0
    case white = 1
}

enum Direction: Int {
    case left = 0
    case right = 1
}

enum Facing: Int, CaseIterable {
    case up = 0
    case left = 1
    case down = 2
    case right = 3
}

/*
 The Intcode program will serve as the brain of the robot. The program uses input instructions to access the robot's camera: provide 0 if the robot is over a black panel or 1 if the robot is over a white panel. Then, the program will output two values:

 First, it will output a value indicating the color to paint the panel the robot is over: 0 means to paint the panel black, and 1 means to paint the panel white.
 Second, it will output a value indicating the direction the robot should turn: 0 means it should turn left 90 degrees, and 1 means it should turn right 90 degrees.
 After the robot turns, it should always move forward exactly one panel. The robot starts facing up.

 The robot will continue running for a while like this and halt when it is finished drawing. Do not restart the Intcode computer inside the robot during this process.


 */

class Robot {
    private let computer: IntcodeComputer
    private(set) var trail: [Point: PaintColor] = [:]
    private(set) var location = Point(x: 0, y: 0)
    private(set) var facing: Facing = .up
    private var outputPointer = 0

    init(program: [Int]) {
        computer = IntcodeComputer(program: program)
    }

    func paint() {
        computer.run(input: [])
        while computer.state != .halted {
            guard computer.state == .waitingForInput else {
                print("Error, robot in an unknown state, expected to be waiting for next input.")
                return
            }

            let currentColor = trail[location] ?? .black
            computer.resume(input: [currentColor.rawValue])

            guard computer.output.count - outputPointer == 2 else {
                print("Error, robot program expected to have 2 new outputs")
                return
            }

            let color = computer.output[outputPointer]
            trail[location] = PaintColor(rawValue: color)!

            let direction = Direction(rawValue: computer.output[outputPointer + 1])!
            move(direction)

            outputPointer += 2
        }
    }

    private func move(_ dir: Direction) {
        switch facing {
        case .up:
            location = Point(x: location.x + (dir == .left ? -1 : 1), y: location.y)
        case .left:
            location = Point(x: location.x, y: location.y + (dir == .left ? -1 : 1))
        case .down:
            location = Point(x: location.x + (dir == .left ? 1 : -1), y: location.y)
        case .right:
            location = Point(x: location.x, y: location.y + (dir == .left ? 1 : -1))
        }

        switch dir {
        case .left:
            facing = Facing(rawValue: (facing.rawValue + 1) % Facing.allCases.count)!
        case .right:
            if facing == .up {
                facing = .right
            } else {
                facing = Facing(rawValue: facing.rawValue - 1)!
            }
            break
        }
    }
}

let robot = Robot(program: input)
robot.paint()

print("number of panels painted: \(robot.trail.count)")
