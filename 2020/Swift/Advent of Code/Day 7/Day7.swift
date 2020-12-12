//
//  Day7.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

struct Content {
  let quantity: Int
  let color: String
}

typealias Rules = [String:[Content]]

class Day7: Day {
  /// How many bag colors can eventually contain at least one shiny gold bag?
  func part1() -> String {
    let rules = makeRules()
    let result = rules.keys.reduce(0) {
      $0 + (canHoldShinyGold(inColor: $1, rules: rules) ? 1 : 0)
    }
    return String(result)
  }
  
  /// How many individual bags are required inside your single shiny gold bag?
  func part2() -> String {
    let rules = makeRules()
    let result = countAllBags(forColor: "shiny gold", rules: rules)
    return String(result)
  }
  
  func makeRules() -> Rules {
    input.lines().reduce(into: [:]) {
      let rule = parseLine($1)
      $0[rule.0] = rule.1
    }
  }
  
  private func parseLine(_ input: String) -> (String, [Content]) {
    let components = input.components(separatedBy: "bags contain")
    let ruleColor = components[0].trimmingCharacters(in: .whitespaces)
    let contents = components[1]
      .split(separator: ",")
      .reduce(into: [Content]()) { (result, content) in
        guard let count = Int(content.trimmingCharacters(in: .whitespaces).split(separator: " ")[0]) else { return }
        let color = content.components(separatedBy: "bag")[0].filter { !$0.isNumber }.trimmingCharacters(in: .whitespaces)
        result.append(Content(quantity: count, color: color))
      }
    return (ruleColor, contents)
  }
  
  private func canHoldShinyGold(inColor color: String, rules: Rules) -> Bool {
    guard color != "shiny gold", let contents = rules[color] else { return false }
    return 0 != contents.reduce(0) { result, content in
      guard content.color != "shiny gold" else { return result + 1 }
      return result + (canHoldShinyGold(inColor: content.color, rules: rules) ? 1 : 0)
    }
  }
  
  private func countAllBags(forColor color: String, rules: Rules) -> Int {
    guard let rule = rules[color] else { return 0 }
    return rule.reduce(0) {
      $0 + $1.quantity + $1.quantity * countAllBags(forColor: $1.color, rules: rules)
    }
  }
}
