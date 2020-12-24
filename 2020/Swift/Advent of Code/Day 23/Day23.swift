//
//  Day23.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day23: Day {
  
  let minCup: Int
  let maxCup: Int
  let cupList: [Int]
  
  override init(input: String) {
    cupList = input.lines()[0].compactMap { $0.wholeNumberValue }
    minCup = cupList.min()!
    maxCup = cupList.max()!
    
    super.init(input: input)
  }

  /// Using your labeling, simulate 100 moves. What are the labels on the cups after cup 1?
  func part1() -> String {
    var cups = makeCups()
    
    // The crab is then going to do 100 moves
    for move in (1...100) {
      print("-- move \(move) --")
      print("cups: \(cups)")
      // The crab picks up the three cups that are immediately clockwise of the current cup. They are removed from the circle; cup spacing is adjusted as necessary to maintain the circle.
      var pickUp = [Int]()
      (1...3).forEach { _ in  pickUp.append(cups.remove(at: 1)!) }
      print("pick up: \(pickUp)")
      
      // The crab selects a destination cup: the cup with a label equal to the current cup's label minus one. If this would select one of the cups that was just picked up, the crab will keep subtracting one until it finds a cup that wasn't just picked up. If at any point in this process the value goes below the lowest value on any cup's label, it wraps around to the highest value on any cup's label instead.
      guard var destinationCup = cups.element(at: 0) else {
        return "Error: Destination cup not found."
      }
      destinationCup -= 1
      if destinationCup < minCup { destinationCup = maxCup }
      while pickUp.contains(destinationCup) {
        destinationCup -= 1
        if destinationCup < minCup { destinationCup = maxCup }
      }
      print("destination: \(destinationCup)")

      // The crab places the cups it just picked up so that they are immediately clockwise of the destination cup. They keep the same order as when they were picked up.
      guard let destinationIndex = cups.firstIndex(of: destinationCup) else {
        return "Error: Destination index not found for cup \(destinationCup)."
      }
      cups.insert(pickUp, after: destinationIndex)
      
      // The crab selects a new current cup: the cup which is immediately clockwise of the current cup.
      cups.moveHead(by: 1)
    }
    
    print("-- final --")
    print("cups: \(cups)")
    
    guard let cup1Index = cups.firstIndex(of: 1) else {
      return "Error: Cups is missing cup 1."
    }
    var result = ""
    for index in (cup1Index + 1)..<(cup1Index+cups.count) {
      if let cup = cups.element(at: index) {
        result.append(String(cup))
      }
    }
    
    print("labels on the cups after cup 1: \(result)")
    
    return result
  }
  
  func part2() -> String {
    "Not Implemented"
  }

  // The cups will be arranged in a circle and labeled clockwise (your puzzle input).
  private func makeCups() -> CircularlyLinkedList<Int> {
    var list = CircularlyLinkedList<Int>()
    list.insert(cupList, at: 0)
    return list
  }
}

