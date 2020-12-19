//
//  Day19.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day19: Day {
  func part1() -> String {
    let components = input.replacingOccurrences(of: "\"", with: "").components(separatedBy: "\n\n")
    var rules = [Int: String]()
    components[0].lines().forEach { line in
      let comps = line.components(separatedBy: ": ")
      rules[Int(comps[0])!] = comps[1]
    }
    
    let pattern = self.pattern(forKey: 0, in: rules)
    print(pattern)
    
    let matches = self.matches(forRegexPattern: "\\b"+pattern+"\\b", in: components[1])
    
    return String(matches.count)
  }
  
  func part2() -> String {
    "Not Implemented"
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
      pattern = pattern.replacingOccurrences(of: "\\b\(sub)\\b", with: subpattern, options: .regularExpression)
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

