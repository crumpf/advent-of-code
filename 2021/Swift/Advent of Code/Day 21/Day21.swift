//
//  Day21.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//
//  https://adventofcode.com/2021/day/21

import Foundation
import CoreText

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
  
  // 3-side die. When rolled universe splits for each outcome of the die. winning score >= 21
  // Using your given starting positions, determine every possible outcome. Find the player that wins in more universes; in how many universes does that player win?
  func part2() -> String {
    let p1 = Player(position: player1StartPosition, score: 0)
    let p2 = Player(position: player2StartPosition, score: 0)
    let result = playDiracGame(board: BoardState(player1: p1, player2: p2))
    print(result)
    
    let most = result.player1Wins > result.player2Wins ? result.player1Wins : result.player2Wins
    return "\(most)"
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
  
  typealias WinTotals = (player1Wins: Int, player2Wins: Int)
  
  // when players are on the board at known positions and scores, the outcome is always the same.
  // so we can map the board state to the winners
  var winners: [BoardState: WinTotals] = [:]
  
  // every time a player plays a turn in the game (rolls the dice 3 times), 3^3 = 27 universes happen, but several of those will play out the same way
  // for the new universes, the unique roll total outcomes and the number of times they occur
  lazy var rollTotalsAndOccurences: [(rollTotal: Int, occurences: Int)] = {
    var map: [Int: Int] = [:]
    for first in 1...3 {
      for second in 1...3 {
        for third in 1...3 {
          let total = first + second + third
          map[total] = 1 + (map[total] ?? 0)
        }
      }
    }
    return map.sorted { $0.key < $1.key }.map { (total: $0.key, occurences: $0.value) }
  }()
  
  func playDiracGame(board: BoardState) -> WinTotals {
    if let wins = winners[board] {
      return wins
    }
    
    let winningMinimum = 21
    var wins: WinTotals = (player1Wins: 0, player2Wins: 0)
    let p1Turns = diracTurn(player: board.player1)
    for t1 in p1Turns {
      if t1.player.score >= winningMinimum {
        wins.player1Wins += t1.occurences
      } else {
        let p2Turns = diracTurn(player: board.player2)
        for t2 in p2Turns {
          if t2.player.score >= winningMinimum {
            wins.player2Wins += t2.occurences * t1.occurences
          } else {
            let b = BoardState(player1: t1.player, player2: t2.player)
            let gameWins = playDiracGame(board: b)
            wins.player1Wins += gameWins.player1Wins * t2.occurences * t1.occurences
            wins.player2Wins += gameWins.player2Wins * t2.occurences * t1.occurences
          }
        }
      }
    }
    
    winners[board] = wins
    
    return wins
  }
  
  // A turn for a player splits into multiple universes, but not all of the new players are unique
  // Playing a turn returns an array of players and the number of times they now occur.
  func diracTurn(player: Player) -> [(player: Player, occurences: Int)] {
    var splitPlayers: [(Player, Int)] = []
    for rolls in rollTotalsAndOccurences {
      var p = player
      p.position = (p.position + rolls.rollTotal) % boardNumberOfSpaces
      p.score += p.position + 1
      splitPlayers.append((p, rolls.occurences))
    }
    return splitPlayers
  }
  
  struct DeterministicDie {
    let numberOfSides = 100
    private(set) var numberOfRolls = 0
    
    // returns the next roll result in 1...numberOfSides, increases numberOfRolls
    mutating func roll() -> Int {
      let result = (numberOfRolls % numberOfSides) + 1
      numberOfRolls += 1
      return result
    }
    
    // multiple roles, returns 0 and does not increase numberOfRolls if times <= 0
    mutating func roll(numberOfTimes times: Int) -> Int {
      guard times > 0 else { return 0 }
      var result = 0
      for _ in 1...times {
        result += roll()
      }
      return result
    }
  }
  
  struct Player: Hashable {
    var position: Int
    var score: Int
  }
  
  struct BoardState: Hashable {
    var player1: Player
    var player2: Player
  }

}
