//
//  main.swift
//  Day 4
//
//  Created by Christopher Rumpf on 12/4/20.
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

class Day4 {
  private func passportsFromInput(_ input: String) -> [Passport] {
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

extension Day4: Puzzle {
  func part1(withInput input: String) -> String {
    let passports = passportsFromInput(input)
    let validCount = passports.filter { $0.isValidPassport() }.count
    return String(describing: validCount)
  }
  
  func part2(withInput input: String) -> String {
    let passports = passportsFromInput(input)
    let validCount = passports.filter { $0.isStrictlyValidPassport() }.count
    return String(describing: validCount)
  }
}

let testInput = """
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
"""

let test2InvalidInput = """
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
"""

let test2ValidInput = """
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
"""

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }


let day = Day4()

print("====Part 1 Test Input====")
let test1 = day.part1(withInput: testInput)
print(test1 == "2" ? "pass" : "fail")

print("====Part 2 Test Input====")
let test2Invalid = day.part2(withInput: test2InvalidInput)
print(test2Invalid == "0" ? "pass" : "fail")
let test2valid = day.part2(withInput: test2ValidInput)
print(test2valid == "4" ? "pass" : "fail")

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.raw)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.raw)
print(part2)
