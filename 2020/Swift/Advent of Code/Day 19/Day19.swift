//
//  Day19.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day19: Day {
  
  var rules: [Int: String]
  let messages: String
  
  override init(input: String) {
    let components = input.components(separatedBy: "\n\n")
    rules = [Int: String]()
    messages = components[1]
    super.init(input: input)
    
    components[0].replacingOccurrences(of: "\"", with: "").lines().forEach { line in
      let comps = line.components(separatedBy: ": ")
      if let key = Int(comps[0]) {
        rules[key] = comps[1]
      }
    }
  }
  
  /// How many messages completely match rule 0?
  func part1() -> String {
    let pattern = self.pattern(forKey: 0, in: rules)
    let matches = self.matches(forRegexPattern: "\\b"+pattern+"\\b", in: messages)
    
    return String(matches.count)
  }
  
  /**
   completely replace rules `8: 42` and `11: 42 31` with the following:
   8: 42 | 42 8
   11: 42 31 | 42 11 31
   
   After updating rules 8 and 11, how many messages completely match rule 0?
   */
  func part2() -> String {
    // Option 1
    // Explicitly add a number of loops to the set of rules to add a finite number of repetitions of rules 8 and 11
    // This is hacky, yeah, but running a few loops will get us the right number.
    rules[8]   = "42 | 42 800"
    rules[800] = "42 | 42 801"
    rules[801] = "42 | 42 802"
    rules[802] = "42 | 42 803"
    rules[803] = "42 | 42 804"
    rules[804] = "42 | 42 805"
    rules[805] = "42"
    rules[11]  = "42 31 | 42 900 31"
    rules[900] = "42 31 | 42 901 31"
    rules[901] = "42 31 | 42 902 31"
    rules[902] = "42 31 | 42 903 31"
    rules[903] = "42 31 | 42 904 31"
    rules[904] = "42 31 | 42 905 31"
    rules[905] = "42 31"
    
    let pattern = self.pattern(forKey: 0, in: rules)
    let matches = self.matches(forRegexPattern: "\\b"+pattern+"\\b", in: messages)
    
    return String(matches.count)
  }
  
  func part2v2() -> String {
    // Option 2
    // Let's try cleaning this up with a single, nasty regex
    // We can use "+" on rule 8 to match 1 or more occurances.
    // On rule 11, we'll iterate from 1 up to some number of recursions
    rules[8] = "42 +"
    var rule11 = "42 {1} 31 {1}"
    (2...5).forEach { n in
      rule11.append(" | 42 {\(n)} 31 {\(n)}")
    }
    rules[11] = rule11
    
    let pattern = self.pattern(forKey: 0, in: rules)
    let matches = self.matches(forRegexPattern: "\\b"+pattern+"\\b", in: messages)
    
    return String(matches.count)
  }
  
  private func pattern(forKey key: Int, in rules: [Int: String]) -> String {
    guard let rule = rules[key] else { return "" }
    
    if rule.count == 1 && rule[0].isLetter {
      return rule
    }
    
    var pattern = rule
    let subrules = Set(rule.components(separatedBy: .whitespaces).compactMap { Int($0) })
    subrules.forEach { sub in
      let subpattern = self.pattern(forKey: sub, in: rules)
      // "\\b(?<!\\{)\(sub)\\b" matches the sub number at word boundaries as long as the word boundary doesn't start with a {, which some patterns might use in order to specify a number of matches required
      pattern = pattern.replacingOccurrences(of: "\\b(?<!\\{)\(sub)\\b", with: subpattern, options: .regularExpression)
    }
    pattern = pattern.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
    if pattern.contains("|") {
      pattern = "(" + pattern + ")"
    }
    return pattern
  }
  
  private func matches(forRegexPattern pattern: String, in text: String) -> [String] {
    do {
      let regex = try NSRegularExpression(pattern: pattern, options: [])
      let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
      return matches.compactMap {
        guard let range = Range($0.range, in: text) else { return nil }
        return String(text[range])
      }
    } catch let error {
      print("Regex error: \(error.localizedDescription)")
      return []
    }
  }
}

