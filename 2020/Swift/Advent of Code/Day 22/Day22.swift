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
  
  /// Play the small crab in a game of Combat using the two decks you just dealt. What is the winning player's score?
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
    
    let result = calculateScore(with: !deck1.isEmpty ? deck1 : deck2)
    
    return String(result)
  }
  
  func part2() -> String {
    let game = play(deck1: playerOneDeck, deck2: playerTwoDeck)
    
    print("== Post-game results ==")
    print("Player 1's deck: \(game.decks.0)")
    print("Player 2's deck: \(game.decks.1)")
    
    let result = calculateScore(with: game.winner == 1 ? game.decks.0 : game.decks.1)
    
    return String(result)
  }
  
  private func calculateScore(with deck: [Int]) -> Int {
    deck.enumerated().reduce(0, { (result, iterElem) in
      result + iterElem.element * (deck.count - iterElem.offset)
    })
  }
  
  /// returns the winner of a round ( 1 or 2 ) given 2 players' decks
  private func play(deck1: [Int], deck2: [Int]) -> (winner: Int, decks: ([Int], [Int])) {
    
    var d1 = deck1
    var d2 = deck2
    var rounds: [([Int], [Int])] = [] // array of tuples (p1 deck, p2 deck) for each round played
    
    while !d1.isEmpty && !d2.isEmpty {
      // Before either player deals a card, if there was a previous round in this game that had exactly the same cards in the same order in the same players' decks, the game instantly ends in a win for player 1. Previous rounds from other games are not considered. (This prevents infinite games of Recursive Combat, which everyone agrees is a bad idea.)
      guard nil == rounds.first(where: { $0 == (d1, d2) }) else {
        return (1, (d1, d2))
      }
      
      rounds.append((d1, d2))
      
      // Otherwise, this round's cards must be in a new configuration; the players begin the round by each drawing the top card of their deck as normal.
      let card1 = d1.removeFirst()
      let card2 = d2.removeFirst()
      var winner = 1

      if d1.count >= card1 && d2.count >= card2 {
        // If both players have at least as many cards remaining in their deck as the value of the card they just drew, the winner of the round is determined by playing a new game of Recursive Combat.
        // To play a sub-game of Recursive Combat, each player creates a new deck by making a copy of the next cards in their deck (the quantity of cards copied is equal to the number on the card they drew to trigger the sub-game).
        winner = play(deck1: Array(d1[0..<card1]), deck2: Array(d2[0..<card2])).winner
      } else {
        // Otherwise, at least one player must not have enough cards left in their deck to recurse; the winner of the round is the player with the higher-value card.
        if card1 > card2 {
          winner = 1
        } else {
          winner = 2
        }
      }
      
      if 1 == winner {
        d1.append(card1)
        d1.append(card2)
      } else {
        d2.append(card2)
        d2.append(card1)
      }
    }
    
    return (d1.isEmpty ? 2 : 1, (d1, d2))
  }
}

