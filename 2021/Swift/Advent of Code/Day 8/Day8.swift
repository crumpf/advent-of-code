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
    let uniqueNumberSegmentsCounts: Set = [2, 3, 4, 7]
    
    let uniqueAppearances = notes.reduce(0) { r, note in
      r + note.displayOutput.reduce(0) { $0 + (uniqueNumberSegmentsCounts.contains($1.count) ? 1 : 0) }
    }
    
    return "\(uniqueAppearances)"
  }
  
  func part2() -> String {
    "Not Implemented"
  }
  
  func makeNotes() -> [NotesEntry] {
    input.lines().map { NotesEntry(note: $0) }
  }
}

struct NotesEntry {
  let signalPatterns: Set<String>
  let displayOutput: [String]
  
  init(note: String) {
    let parts = note.components(separatedBy: " | ")
    signalPatterns = Set(parts[0].components(separatedBy: .whitespaces))
    displayOutput = parts[1].components(separatedBy: .whitespaces)
  }
}

