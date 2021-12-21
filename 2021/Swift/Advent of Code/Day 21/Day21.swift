//
//  Day21.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day21: Day {
  func part1() -> String {
    var p1 = Player(position: player1StartPosition, score: 0)
    var p2 = Player(position: player2StartPosition, score: 0)
    var die = DeterministicDie()
    let winningMinimum = 1000
    
    while p1.score < winningMinimum || p2.score < winningMinimum {
      var result = die.roll(numberOfTimes: 3)
      p1.position = (p1.position + result) % boardNumberOfSpaces
      p1.score += p1.position + 1
//      print("Player 1 moves to space \(p1.position + 1) total score \(p1.score)")
      if p1.score >= winningMinimum {
        break
      }
      
      result = die.roll(numberOfTimes: 3)
      p2.position = (p2.position + result) % boardNumberOfSpaces
      p2.score += p2.position + 1
//      print("Player 2 moves to space \(p2.position + 1) total score \(p2.score)")
    }
    
    var winner = p1
    var loser = p2
    if p1.score < winningMinimum {
      winner = p2
      loser = p1
    }
    
    return "\(loser.score * die.numberOfRolls)"
  }
  
  func part2() -> String {
    return ""
  }
  
  let player1StartPosition: Int
  let player2StartPosition: Int
  let boardNumberOfSpaces = 10

  override init(input: String) {
    let parts = input.lines()
    // we store position 0-based, input given 1-based
    self.player1StartPosition = Int(parts[0].components(separatedBy: .whitespaces).last!)! - 1
    self.player2StartPosition = Int(parts[1].components(separatedBy: .whitespaces).last!)! - 1
    
    super.init(input: input)
  }
  
  struct DeterministicDie {
    let numberOfSides = 100
    private(set) var numberOfRolls = 0
    
    mutating func roll() -> Int {
      let result = (numberOfRolls % numberOfSides) + 1
      numberOfRolls += 1
      return result
    }
    
    mutating func roll(numberOfTimes times: Int) -> Int {
      guard times > 0 else { return 0 }
      var result = 0
      for _ in 1...times {
        result += roll()
      }
      return result
    }
  }
  
  struct Player {
    var position: Int
    var score: Int
  }

}

