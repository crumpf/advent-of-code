//
//  main.swift
//  Day 7
//
//  Created by Christopher Rumpf on 12/3/20.
//

import Foundation

struct Content {
  let quantity: Int
  let color: String
}

typealias Rules = [String:[Content]]

class Day7 {
  func makeRules(input: String) -> Rules {
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
        guard !content.contains("no other") else { return }
        let count = Int(content.trimmingCharacters(in: .whitespaces).split(separator: " ")[0])
        let color = content.components(separatedBy: "bag")[0].filter { !$0.isNumber }.trimmingCharacters(in: .whitespaces)
        result.append(Content(quantity: count!, color: color))
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

extension Day7: Puzzle {
  func part1(withInput input: String) -> String {
    let rules = makeRules(input: input)
    let result = rules.keys.reduce(0) {
      $0 + (canHoldShinyGold(inColor: $1, rules: rules) ? 1 : 0)
    }
    return String(result)
  }
  
  func part2(withInput input: String) -> String {
    let rules = makeRules(input: input)
    let result = countAllBags(forColor: "shiny gold", rules: rules)
    return String(result)
  }
}

let testInput = """
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
"""

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day7()

print("====Test 1====")
let test1 = day.part1(withInput: testInput)
print(test1)

print("====Test 2====")
let test2 = day.part2(withInput: testInput)
print(test2)

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.raw)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.raw)
print(part2)
