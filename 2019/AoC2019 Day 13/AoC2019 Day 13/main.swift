//
//  main.swift
//  AoC2019 Day 13
//
//  Created by Christopher Rumpf on 12/30/19.
//  Copyright © 2019 Christopher Rumpf. All rights reserved.
//

import Foundation

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

// Day 13: Care Package

enum Tile: Int {
  case empty = 0
  case wall
  case block
  case horizontalPaddle
  case ball
}

class ArcadeCabinet {
  private let computer: IntcodeComputer
  private var wall = Set<SIMD2<Int>>([])
  private var blocks = Set<SIMD2<Int>>([])
  private var paddle = Set<SIMD2<Int>>([])
  private var ball = Set<SIMD2<Int>>([])
  
  init(program: [Int]) {
    computer = IntcodeComputer(program: program)
  }
  
  func start() {
    while computer.state != .halted {
      if let xpos = computer.run(input: []),
        let ypos = computer.run(input: []),
        let tileId = computer.run(input: []) {
        guard let tile = Tile(rawValue: tileId) else {
          print("Error: invalid tile id found")
          return
        }
        let xy = SIMD2(x: xpos, y: ypos)
        switch tile {
        case .empty:
          emptyTile(at: xy)
        case .wall:
          wall.insert(xy)
        case .block:
          blocks.insert(xy)
        case .horizontalPaddle:
          paddle.insert(xy)
        case .ball:
          ball.insert(xy)
        }
      }
    }
  }
  
  private func emptyTile(at: SIMD2<Int>) {
    blocks.remove(at)
    paddle.remove(at)
    ball.remove(at)
  }
  
  func numberOfBlockTiles() -> Int {
    return blocks.count
  }
}

let program = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }
let cabinet = ArcadeCabinet(program: program)
cabinet.start()

print("number of block tiles on screen: \(cabinet.numberOfBlockTiles())")
