//
//  Day4.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/4/21.
//
//  https://adventofcode.com/2021/day/4

import Foundation

class Day4: Day {
  /// Final score for the winning board.
  func part1() -> String {
    var bingo = Bingo(input: input)
    guard let result = try? bingo.play1() else {
      return "No result"
    }
    return "\(result)"
  }
  
  /// Let the giant squid win.
  func part2() -> String {
    var bingo = Bingo(input: input)
    guard let result = try? bingo.play2() else {
      return "No result"
    }
    return "\(result)"
  }
}

typealias Space = (num: Int, marked: Bool)
typealias BingoBoard = [[Space]]

struct Bingo {
  let drawOrder: [Int]
  var boards: [BingoBoard]
  private(set) var numbersDrawn = 0
  
  init(input: String) {
    let parts = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")
    drawOrder = parts.first!.components(separatedBy: ",").compactMap { Int ($0) }
    boards = parts.dropFirst().map {
      $0.components(separatedBy: .newlines)
        .map {
          $0.components(separatedBy: .whitespaces).compactMap {
            $0.isEmpty ? nil : (Int($0)!, false) }
        }
    }
  }
  
  enum BingoError: Error {
    case alreadyPlayed
    case noWinners
  }
  
  // plays a game based on Part 1 conditions
  mutating func play1() throws -> Int {
    guard numbersDrawn == 0 else {
      throw BingoError.alreadyPlayed
    }
    
    var score: Int = -1
    var winningBoard: Int?
    for drawn in drawOrder {
      guard winningBoard == nil else {
        break
      }
      numbersDrawn += 1
      // mark boards and check for winner
      boards.indices.forEach { boardIndex in
        if let found = boards[boardIndex].locate(drawn) {
          boards[boardIndex][found.row][found.col].marked = true
          if boards[boardIndex].isWinner() {
            winningBoard = boardIndex
            score = boards[boardIndex].sumOfUnmarked() * drawn
            return
          }
        }
      }
    }
    
    guard let winningBoard = winningBoard else {
      throw BingoError.noWinners
    }
    
    print("winningBoard: \(winningBoard), score: \(score)")
    
    return score
  }
  
  // plays a game based on Part 2 conditions
  mutating func play2() throws -> Int {
    guard numbersDrawn == 0 else {
      throw BingoError.alreadyPlayed
    }
    
    var score: Int = -1
    var winningBoards: [Int] = []
    for drawn in drawOrder {
      numbersDrawn += 1
      // mark boards and check for winner
      boards.indices.forEach { boardIndex in
        if let found = boards[boardIndex].locate(drawn) {
          boards[boardIndex][found.row][found.col].marked = true
          if boards[boardIndex].isWinner() {
            winningBoards.append(boardIndex)
            score = boards[boardIndex].sumOfUnmarked() * drawn
          }
        }
      }
      if !winningBoards.isEmpty {
        winningBoards.sorted(by: >).forEach {
          boards.remove(at: $0)
        }
        if boards.isEmpty {
          break
        } else {
          winningBoards.removeAll()
        }
      }
    }
    
    return score
  }
}

extension BingoBoard {
  func locate(_ num: Int) -> (row: Int, col: Int)? {
    for row in self.enumerated() {
      for col in row.element.enumerated() {
        if col.element.num == num {
          return (row: row.offset, col: col.offset)
        }
      }
    }
    return nil
  }
  
  func isWinner() -> Bool {
    for n in 0..<5 {
      // any complete rows?
      if (self[n].filter { $0.marked }.count) == 5 {
        return true
      }
      // any complete cols?
      if (self.filter { $0[n].marked }.count) == 5 {
        return true
      }
    }
    return false
  }
  
  func sumOfUnmarked() -> Int {
    self.reduce(0) {
      $0 + $1.reduce(0) { $0 + ($1.marked ? 0 : $1.num) }
    }
  }
  
}
