//
//  Day02.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 11/30/22.
//

import Foundation

class Day02: Day {
  enum HandShape: Int {
    case rock = 1, paper = 2, scissors = 3
  }
  
  enum Winner: Int {
    case opponent = 0, tie = 3, me = 6
  }
  
  private func decodeOpponentCode(_ code: String) throws -> HandShape {
    switch code {
    case "A": return .rock
    case "B": return .paper
    case "C": return .scissors
    default: throw NSError(domain: "Could not decode (\(code))", code: -1)
    }
  }
  
  private func decodeMyCodeExpectingItIsAHandShape(code: String) throws -> HandShape {
    switch code {
    case "X": return .rock
    case "Y": return .paper
    case "Z": return .scissors
    default: throw NSError(domain: "Could not decode (\(code))", code: -1)
    }
  }
  
  private func decodeMyCodeIndicatingRoundEnding(code: String, opponentShape: HandShape) throws -> HandShape {
    switch code {
    case "X":
      // need to lose
      switch opponentShape {
      case .rock: return .scissors
      case .paper: return .rock
      case .scissors: return .paper
      }
    case "Y":
      // need to end in a draw
      return opponentShape
    case "Z":
      // need to win
      switch opponentShape {
      case .rock: return .paper
      case .paper: return .scissors
      case .scissors: return .rock
      }
    default: throw NSError(domain: "Could not decode (\(code))", code: -1)
    }
  }
  
  func scoreFromStrategyGuide(_ guide: [(HandShape, HandShape)]) -> Int {
    guide.reduce(0) { partialResult, prediction in
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
  }
  
  func part1() -> String {
    let decodedStrategyGuide: [(HandShape, HandShape)] = input
      .lines()
      .compactMap {
        let segmented = $0.split(separator: " ")
        return (try! decodeOpponentCode(String(segmented[0])),
                try! decodeMyCodeExpectingItIsAHandShape(code: String(segmented[1])))
      }
    
    return "\(scoreFromStrategyGuide(decodedStrategyGuide))"
  }
  
  func part2() -> String {
    let decodedStrategyGuide: [(HandShape, HandShape)] = input
      .lines()
      .compactMap {
        let segmented = $0.split(separator: " ")
        let opponentShape = try! decodeOpponentCode(String(segmented[0]))
        return (
          opponentShape,
          try! decodeMyCodeIndicatingRoundEnding(code: String(segmented[1]), opponentShape: opponentShape)
        )
      }
    
    return "\(scoreFromStrategyGuide(decodedStrategyGuide))"
  }
}

