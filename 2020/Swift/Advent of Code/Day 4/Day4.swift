//
//  Day4.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

typealias Passport = [String:String]

extension Passport where Key == String, Value == String {
  func isValidPassport() -> Bool {
    if count == 8 { return true }
    if count == 7 && self["cid"] == nil { return true }
    return false
  }
  
  func isStrictlyValidPassport() -> Bool {
    guard let byr = self["byr"],
          let iyr = self["iyr"],
          let eyr = self["eyr"],
          let hgt = self["hgt"],
          let hcl = self["hcl"],
          let ecl = self["ecl"],
          let pid = self["pid"] else { return false }
    
    guard (1920...2002).contains(Int(byr)!) else { return false }
    guard (2010...2020).contains(Int(iyr)!) else { return false }
    guard (2020...2030).contains(Int(eyr)!) else { return false }
    if hgt.hasSuffix("cm") {
      guard let ht = Int(hgt.dropLast(2)), (150...193).contains(ht) else { return false }
    } else if hgt.hasSuffix("in") {
      guard let ht = Int(hgt.dropLast(2)), (59...76).contains(ht) else { return false }
    } else {
      return false
    }
    guard hcl.range(of: #"^#[0-9a-fA-F]{6}$"#, options: .regularExpression) != nil else { return false }
    guard ecl.range(of: #"^(amb|blu|brn|gry|grn|hzl|oth)$"#, options: .regularExpression) != nil else { return false }
    guard pid.range(of: #"^[0-9]{9}$"#, options: .regularExpression) != nil else { return false }
    return true
  }
}

class Day4: Day {
  /// Count the number of valid passports - those that have all required fields. Treat cid as optional. In your batch file, how many passports are valid?
  func part1() -> String {
    let passports = makePassports()
    let validCount = passports.filter { $0.isValidPassport() }.count
    return String(describing: validCount)
  }
  
  /// Count the number of valid passports - those that have all required fields and valid values. Continue to treat cid as optional. In your batch file, how many passports are valid?
  func part2() -> String {
    let passports = makePassports()
    let validCount = passports.filter { $0.isStrictlyValidPassport() }.count
    return String(describing: validCount)
  }
  
  private func makePassports() -> [Passport] {
    var passports: [Passport] = []
    var passport: Passport = [:]
    for line in input.lines() {
      if line.isEmpty {
        if !passport.isEmpty {
          passports.append(passport)
          passport.removeAll()
        }
      } else {
        for field in line.components(separatedBy: .whitespaces) {
          let components = field.components(separatedBy: ":")
          if components.count == 2 {
            passport[components[0]] = components[1]
          } else {
            abort() // something is wrong
          }
        }
      }
    }
    
    if !passport.isEmpty { passports.append(passport) }
    return passports
  }
}
