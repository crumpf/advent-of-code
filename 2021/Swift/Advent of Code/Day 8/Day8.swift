//
//  Day8.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//
//  https://adventofcode.com/2021/day/8#part2

import Foundation

class Day8: Day {
  func part1() -> String {
    let notes = makeNotes()
    let uniqueNumberSegmentsCounts: Set = [Display.one.count, Display.four.count, Display.seven.count, Display.eight.count]
    
    let uniqueAppearances = notes.reduce(0) { r, note in
      r + note.displayOutput.reduce(0) { $0 + (uniqueNumberSegmentsCounts.contains($1.count) ? 1 : 0) }
    }
    
    return "\(uniqueAppearances)"
  }
  
  func part2() -> String {
    let notes = makeNotes()
    let sum = notes.reduce(0) { r, note in
      r + note.decode()!
    }
    return "\(sum)"
  }
  
  func makeNotes() -> [NotesEntry] {
    input.lines().map { NotesEntry(note: $0) }
  }

}

struct NotesEntry {
  let signalPatterns: [Set<Character>]
  let displayOutput: [Set<Character>]
  
  init(note: String) {
    let parts = note.components(separatedBy: " | ")
    signalPatterns = parts[0].components(separatedBy: .whitespaces).map { Set($0) }
    displayOutput = parts[1].components(separatedBy: .whitespaces).map { Set($0) }
  }
  
  func decode() -> Int? {
    var signalsForDigits: [Set<Character>] = Array(repeating: [], count: 10)
    // populate the numbers with those having unique counts
    signalsForDigits[1] = signalPatterns.first { $0.count == Display.one.count }!
    signalsForDigits[4] = signalPatterns.first { $0.count == Display.four.count }!
    signalsForDigits[7] = signalPatterns.first { $0.count == Display.seven.count }!
    signalsForDigits[8] = signalPatterns.first { $0.count == Display.eight.count }!
        
    var decodedSegments: [Character:Character] = [:]
    // find segment a
    decodedSegments["a"] = signalsForDigits[1].symmetricDifference(signalsForDigits[7]).first
    // find #9 and segment g
    let _ = signalPatterns.first { pattern in
      guard pattern.count == Display.nine.count else { return false }
      let segments = signalsForDigits[4].union(signalsForDigits[7])
      let remainder = pattern.subtracting(segments)
      if remainder.count == 1 {
        signalsForDigits[9] = pattern
        decodedSegments["g"] = remainder.first
        return true
      }
      return false
    }
    // find segment e
    decodedSegments["e"] = signalsForDigits[8].subtracting(signalsForDigits[9]).first
    // find #3 and segment d
    let _ = signalPatterns.first { pattern in
      guard pattern.count == Display.three.count else { return false }
      let remainder = pattern.subtracting(signalsForDigits[1].union([decodedSegments["a"]!, decodedSegments["g"]!]))
      if remainder.count == 1 {
        signalsForDigits[3] = pattern
        decodedSegments["d"] = remainder.first
        return true
      }
      return false
    }
    // find #2 and segment c
    let _ = signalPatterns.first { pattern in
      guard pattern.count == Display.two.count else { return false }
      let segments = Set([decodedSegments["a"]!,
                          decodedSegments["d"]!,
                          decodedSegments["e"]!,
                          decodedSegments["g"]!])
      let remainder = pattern.subtracting(segments)
      if remainder.count == 1 {
        signalsForDigits[2] = pattern
        decodedSegments["c"] = remainder.first
        return true
      }
      return false
    }
    // find segment f
    decodedSegments["f"] = signalsForDigits[1].subtracting([decodedSegments["c"]!]).first
    // finally, segment b
    decodedSegments["b"] = signalsForDigits[8].subtracting(decodedSegments.values).first
    
    // now we have all the signals decoded to their segments, find remaining digits
    for (n, d) in signalsForDigits.enumerated() {
      if d.isEmpty {
        signalsForDigits[n] = Set(Display.segments[n].compactMap { decodedSegments[$0] })
      }
    }

    // decode the 4 digit output value
    
    let digits = displayOutput.compactMap { signalsForDigits.firstIndex(of: $0) }
    let value = Int(digits.map { String($0) }.joined(separator: ""))
    
    return value
  }
}

// the 7-segment display has segments 'a' through 'g'
//  aaaa
// b    c
// b    c
//  dddd
// e    f
// e    f
//  gggg
struct Display {
  // map numbers 0-9 (the array index) to the set of segments that represent that number on the display
  static let zero  = Set("abcefg")
  static let one   = Set("cf")
  static let two   = Set("acdeg")
  static let three = Set("acdfg")
  static let four  = Set("bcdf")
  static let five  = Set("abdfg")
  static let six   = Set("abdefg")
  static let seven = Set("acf")
  static let eight = Set("abcdefg")
  static let nine  = Set("abcdfg")
  static let segments = [zero, one, two, three, four, five, six, seven, eight, nine]
}
