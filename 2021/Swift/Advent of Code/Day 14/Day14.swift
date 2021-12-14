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
  
  // The polymer length grows exponentially and quickly grows too large for my full polymer
  // growth in part1. So, a new approach is needed. This approach will not allow us to see the
  // ordered sequence of the polymer, but we can count the elements at each stage this way which
  // is sufficient to solve today's problem.
  func part2() -> String {
    let instructions = PolymerInstructions(input: input)
    /// running total of counts for elements added at each stage, seeded with the instruction template
    var totalElementCounts: [String: Int] = instructions.polymerTemplate
      .reduce(into: [String: Int]()) { partialResult, c in
        let element = String(c)
        partialResult[element] = 1 + (partialResult[element] ?? 0)
      }
    /// the element pairs  and their number of occurences for a given step, seeded with the pairs found in the instruction template
    var pairCounts: [String: Int] = pairs(inTemplate: instructions.polymerTemplate)
      .reduce(into: [String: Int]()) { partialResult, pair in
        partialResult[pair] = 1 + (partialResult[pair] ?? 0)
      }
    
    for _ in 1...40 {
      /// at each step, we will calculate the pairs to be used in the future step and their number of occurences
      var nextPairs: [String: Int] = [:]
      for (pair, count) in pairCounts {
        if let insert = instructions.pairInsertions[pair] {
          // 1. map the pair to the element to insert and increase it's count in our map of element counts (we're inserting this many more of the element into the polymer)
          totalElementCounts[insert] = count + (totalElementCounts[insert] ?? 0)
          // 2. figure out what pairs we'll explore in the next step. add 2 new pairs resulting from inserting the new element into the nextPairs map
          let first = String(pair[0]) + insert
          let second = insert + String(pair[1])
          nextPairs[first] = count + (nextPairs[first] ?? 0)
          nextPairs[second] = count + (nextPairs[second] ?? 0)
        }
      }
      pairCounts = nextPairs
    }
    
    let ordered = totalElementCounts.sorted { $0.value > $1.value }
    
    return "\(ordered.first!.value - ordered.last!.value)"
  }
  
  func polymer(forTemplate template: String, pairInsertions: [String: String]) -> String {
    var polymer = ""
    for pair in pairs(inTemplate: template) {
      let element = pairInsertions[pair]
      polymer += "\(pair.first!)\(element!)"
    }
    return "\(polymer)\(template.last!)"
  }
  
  func pairs(inTemplate template: String) -> [String] {
    var pairs: [String] = []
    for n in 0..<template.count-1 {
      pairs.append(String(template[n...n+1]))
    }
    return pairs
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
