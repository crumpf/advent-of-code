//
//  Day22.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day22: Day {
  override init(input: String) {
    let components = input.components(separatedBy: "\n\n")
    playerOneDeck = components[0].lines().dropFirst().compactMap { Int($0) }
    playerTwoDeck = components[1].lines().dropFirst().compactMap { Int($0) }
    
    super.init(input: input)
  }
  
  let playerOneDeck: [Int]
  let playerTwoDeck: [Int]
  
  func part1() -> String {
    var deck1 = playerOneDeck
    var deck2 = playerTwoDeck
    
    while !deck1.isEmpty && !deck2.isEmpty {
      let card1 = deck1.removeFirst()
      let card2 = deck2.removeFirst()
      
      if card1 > card2 {
        deck1.append(card1)
        deck1.append(card2)
      } else {
        deck2.append(card2)
        deck2.append(card1)
      }
    }
    
    print("== Post-game results ==")
    print("Player 1's deck: \(deck1)")
    print("Player 2's deck: \(deck2)")
    
    var result = 0
    if (!deck1.isEmpty) {
      result = deck1.enumerated().reduce(0, { (result, iterElem) in
        result + iterElem.element * (deck1.count - iterElem.offset)
      })
    } else {
      result = deck2.enumerated().reduce(0, { (result, iterElem) in
        result + iterElem.element * (deck2.count - iterElem.offset)
      })
    }
    
    return String(result)
  }
  
  func part2() -> String {
    "Not Implemented"
  }
}

