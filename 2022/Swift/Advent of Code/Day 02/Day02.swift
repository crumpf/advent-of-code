//
//  Day02.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 11/30/22.
//

import Foundation

class Day02: Day {
  enum HandShape {
    case rock, paper, scissors
  }
  
  enum Outcome {
    case loss, draw, win
  }
  
  private func scoreOf(_ shape: HandShape) -> Int {
    switch shape {
    case .rock:     return 1
    case .paper:    return 2
    case .scissors: return 3
    }
  }
  
  private func scoreOf(_ outcome: Outcome) -> Int {
    switch outcome {
    case .loss: return 0
    case .draw: return 3
    case .win:  return 6
    }
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
    case "X": // need to lose
      switch opponentShape {
      case .rock: return .scissors
      case .paper: return .rock
      case .scissors: return .paper
      }
    case "Y": // need to end in a draw
      return opponentShape
    case "Z": // need to win
      switch opponentShape {
      case .rock: return .paper
      case .paper: return .scissors
      case .scissors: return .rock
      }
    default: throw NSError(domain: "Could not decode (\(code))", code: -1)
    }
  }
  
  private func scoreFromStrategyGuide(_ guide: [(HandShape, HandShape)]) -> Int {
    guide.reduce(0) { partialResult, prediction in
      var outcome: Outcome = .draw
      switch prediction {
      case (.rock, .paper): outcome = .win
      case (.rock, .scissors): outcome = .loss
      case (.paper, .rock): outcome = .loss
      case (.paper, .scissors): outcome = .win
      case (.scissors, .rock): outcome = .win
      case (.scissors, .paper): outcome = .loss
      default: outcome = .draw
      }
      return partialResult + scoreOf(prediction.1) + scoreOf(outcome)
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

