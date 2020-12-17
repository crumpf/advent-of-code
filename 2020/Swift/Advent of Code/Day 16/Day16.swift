//
//  Day16.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

struct Rule: Hashable {
  let name: String
  let ranges: [ClosedRange<Int>]
  
  func isValid(with value: Int) -> Bool {
    for r in ranges {
      if r.contains(value) { return true }
    }
    return false
  }
}

class Day16: Day {
  let rules: [Rule]
  let myTicket: [Int]
  let nearbyTickets: [[Int]]
  
  override init(input: String) {
    let components = input.components(separatedBy: "\n\n")
    
    rules = components[0].lines().map { ruleString -> Rule in
      let parts = ruleString.components(separatedBy: ":")
      let name = parts[0]
      let ranges = parts[1]
        .trimmingCharacters(in: .whitespaces)
        .components(separatedBy: " or ")
        .map { rangeString -> ClosedRange<Int> in
          let bounds = rangeString.components(separatedBy: "-")
          return Int(bounds[0])!...Int(bounds[1])!
        }
      return Rule(name: name, ranges: ranges)
    }
    
    myTicket = components[1].lines()[1].components(separatedBy: ",").map { Int($0)! }
    
    nearbyTickets = components[2].lines().dropFirst().map {
       $0.components(separatedBy: ",").map { Int($0)! }
     }
    
    super.init(input: input)
  }
  
  /// Consider the validity of the nearby tickets you scanned. What is your ticket scanning error rate?
  func part1() -> String {
    // you can identify invalid nearby tickets by considering only whether tickets contain values that are not valid for any field
    var valuesNotValidForAnyField: [Int] = []
    for ticket in nearbyTickets {
      for value in ticket {
        if !rules.contains(where: { $0.isValid(with: value) }) {
          valuesNotValidForAnyField.append(value)
        }
      }
    }
    
    return String(valuesNotValidForAnyField.reduce(0, +))
  }
  
  /// work out which field is which, look for the six fields on your ticket that start with the word departure. What do you get if you multiply those six values together?
  func part2() -> String {
    // discard nearby tickets not valid for any field
    let validTickets = nearbyTickets.filter { ticket -> Bool in
      ticket.allSatisfy { value -> Bool in
        rules.contains(where: { $0.isValid(with: value) })
      }
    }
    
    // find eligible fields for each column in our nearby tickets
    var fieldsForColumn = Array(repeating: Set<Rule>(), count: myTicket.count)
    for index in myTicket.indices {
      let column = validTickets.map { $0[index] }
      for rule in rules {
        if column.allSatisfy({value in rule.isValid(with: value)}) {
          fieldsForColumn[index].insert(rule)
        }
      }
    }
    
    // now we have to reduce the sets of eligible fields and lock the fields down
    var locked: [Int: Rule] = [:]
    while locked.count < fieldsForColumn.count {
      for (i, fields) in fieldsForColumn.enumerated() {
        if let rule = fields.first, fields.count == 1, nil == locked[i] {
          // found the next index to lock in
          locked[i] = rule
          fieldsForColumn.indices.forEach { fieldsForColumn[$0].remove(rule) }
        }
      }
    }
    
    let result = locked
      .compactMap { $0.value.name.hasPrefix("departure") ? $0.key : nil }
      .map { myTicket[$0] }
      .reduce(1, *)
      
    return String(result)
  }
  
}

