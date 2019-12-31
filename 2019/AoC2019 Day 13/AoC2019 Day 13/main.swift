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
  
  private(set) var score = 0
  
  init(program: [Int]) {
    computer = IntcodeComputer(program: program)
  }
  
  func start() {
    while computer.state != .halted {
      var input: [Int] = []
      if computer.state == .waitingForInput {
        if let b = ball.randomElement(), let p = paddle.randomElement() {
          if b.x < p.x {
            input = [-1]
          } else if b.x > p.x {
            input = [1]
          } else {
            input = [0]
          }
        } else {
          return
        }
      }
      if let xpos = computer.run(input: input),
        let ypos = computer.run(input: []),
        let value = computer.run(input: []) {
        
        let xy = SIMD2(x: xpos, y: ypos)
        if xy == SIMD2(x: -1, y: 0) {
          // When three output instructions specify X=-1, Y=0, the third output instruction is not a tile; the value instead specifies the new score to show in the segment display.
          score = value
          continue
        }
        
        guard let tile = Tile(rawValue: value) else {
          print("Error: invalid tile id found")
          return
        }
        
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
      print("score: \(score), blocks count: \(blocks.count)")
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

// PART 2

var program2 = fileInput.components(separatedBy: "\n")[0].components(separatedBy: ",").compactMap { Int($0) }
program2[0] = 2 // Memory address 0 represents the number of quarters that have been inserted; set it to 2 to play for free.
let cabinet2 = ArcadeCabinet(program: program2)
cabinet2.start()

print("final score: \(cabinet2.score)")
