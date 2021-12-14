//
//  Day14.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day14: Day {
  func part1() -> String {
    let instructions = PolymerInstructions(input: input)
    var poly = instructions.polymerTemplate
    for _ in 1...10 {
      poly = polymer(forTemplate: poly, pairInsertions: instructions.pairInsertions)
    }
    var elementCounts: [String: Int] = [:]
    let elementSet = Set(instructions.pairInsertions.values)
    for e in elementSet {
      elementCounts[e] = poly.filter { String($0) == e }.count
    }
    let ordered = elementSet.sorted { first, second in
      elementCounts[first]! > elementCounts[second]!
    }
    return "\(elementCounts[ordered.first!]! - elementCounts[ordered.last!]!)"
  }
  
  func part2() -> String {
    return ""
  }
  
  func polymer(forTemplate template: String, pairInsertions: [String: String]) -> String {
    var polymer = ""
    for n in 0..<template.count-1 {
      let pair = String(template[n...n+1])
      let element = pairInsertions[pair]
      polymer += "\(pair.first!)\(element!)"
    }
    return "\(polymer)\(template.last!)"
  }
}

struct PolymerInstructions {
  let polymerTemplate: String
  let pairInsertions: [String: String]
  
  init(input: String) {
    let parts = input.components(separatedBy: "\n\n")
    polymerTemplate = parts[0]
    var insertions: [String: String] = [:]
    for insertString in parts[1].lines() {
      let insertParts = insertString.components(separatedBy: " -> ")
      insertions[insertParts[0]] = insertParts[1]
    }
    pairInsertions = insertions
  }
}
