//
//  Day02.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 11/30/22.
//

import Foundation

class Day02: Day {
  enum RPS: Int {
    case rock = 1, paper = 2, scissors = 3
  }
  
  enum Winner: Int {
    case opponent = 0, tie = 3, me = 6
  }
  
  private lazy var decodedStrategyGuide: [(RPS, RPS)] = input
    .lines()
    .compactMap {
      let segmented = $0.split(separator: " ")
      return (try! decodeOpponentCharacter(String(segmented[0])),
              try! decodeMyCharacter(String(segmented[1])))
    }
  
  private func decodeOpponentCharacter(_ character: String) throws -> RPS {
    switch character {
    case "A": return .rock
    case "B": return .paper
    case "C": return .scissors
    default: throw NSError(domain: "Could not decode (\(character))", code: -1)
    }
  }
  
  private func decodeMyCharacter(_ character: String) throws -> RPS {
    switch character {
    case "X": return .rock
    case "Y": return .paper
    case "Z": return .scissors
    default: throw NSError(domain: "Could not decode (\(character))", code: -1)
    }
  }
  
  func part1() -> String {
    let score = decodedStrategyGuide.reduce(0) { partialResult, prediction in
      var winner: Winner = .tie
      switch prediction {
      case (.rock, .paper): winner = .me
      case (.rock, .scissors): winner = .opponent
      case (.paper, .rock): winner = .opponent
      case (.paper, .scissors): winner = .me
      case (.scissors, .rock): winner = .me
      case (.scissors, .paper): winner = .opponent
      default: winner = .tie
      }
      return partialResult + prediction.1.rawValue + winner.rawValue
    }
    return "\(score)"
  }
  
  func part2() -> String {
    "Not Implemented"
  }
}

