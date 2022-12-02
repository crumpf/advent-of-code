//
//  Day02Alternative.swift
//  Day 02
//
//  Created by Christopher Rumpf on 12/2/22.
//

import Foundation

class Day02Alternative: Day {
  
  enum HandShape: Int {
      case rock = 1, paper = 2, scissors = 3
  }

  enum Outcome: Int {
      case loss = 0, draw = 3, win = 6
  }
  
  // A=rock B=paper C=scissors
  // X=rock Y=paper Z=scissors
  private let part1Map = [
      "A X" : Outcome.draw.rawValue + HandShape.rock.rawValue,
      "A Y" : Outcome.win.rawValue  + HandShape.paper.rawValue,
      "A Z" : Outcome.loss.rawValue + HandShape.scissors.rawValue,
      "B X" : Outcome.loss.rawValue + HandShape.rock.rawValue,
      "B Y" : Outcome.draw.rawValue + HandShape.paper.rawValue,
      "B Z" : Outcome.win.rawValue  + HandShape.scissors.rawValue,
      "C X" : Outcome.win.rawValue  + HandShape.rock.rawValue,
      "C Y" : Outcome.loss.rawValue + HandShape.paper.rawValue,
      "C Z" : Outcome.draw.rawValue + HandShape.scissors.rawValue
  ]

  // A=rock B=paper C=scissors
  // X=needLose Y=needDraw Z=needWin
  private let part2Map = [
      "A X" : Outcome.loss.rawValue + HandShape.scissors.rawValue,
      "A Y" : Outcome.draw.rawValue + HandShape.rock.rawValue,
      "A Z" : Outcome.win.rawValue  + HandShape.paper.rawValue,
      "B X" : Outcome.loss.rawValue + HandShape.rock.rawValue,
      "B Y" : Outcome.draw.rawValue + HandShape.paper.rawValue,
      "B Z" : Outcome.win.rawValue  + HandShape.scissors.rawValue,
      "C X" : Outcome.loss.rawValue + HandShape.paper.rawValue,
      "C Y" : Outcome.draw.rawValue + HandShape.scissors.rawValue,
      "C Z" : Outcome.win.rawValue  + HandShape.rock.rawValue
  ]
  
  func part1() -> String {
    "\(input.lines().reduce(0) { $0 + (part1Map[$1] ?? 0) })"
  }
  
  func part2() -> String {
    "\(input.lines().reduce(0) { $0 + (part2Map[$1] ?? 0) })"
  }

}
