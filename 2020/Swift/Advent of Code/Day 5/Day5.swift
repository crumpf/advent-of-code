//
//  Day5.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

struct BoardingPass {
  let row, column, seatID: Int
  
  init(row: Int, column: Int) {
    self.row = row
    self.column = column
    self.seatID = row * 8 + column
  }
}

class Day5: Day {
  /// What is the highest seat ID on a boarding pass?
  func part1() -> String {
    String(boardingPasses().map { $0.seatID }.max()!)
  }
  
  /// Your seat wasn't at the very front or back, though; the seats with IDs +1 and -1 from yours will be in your list.
  /// What is the ID of your seat?
  func part2() -> String {
    let boardingPasses = self.boardingPasses().sorted { $0.seatID < $1.seatID }
    
    var mySeatID = -1
    for (index, pass) in boardingPasses.enumerated() {
      if pass.seatID - index != boardingPasses.first!.seatID {
        mySeatID = pass.seatID - 1
        break
      }
    }
    
    return String(mySeatID)
  }
  
  private func boardingPasses() -> [BoardingPass] {
    input.lines().map { (s) -> BoardingPass in
      var row = 0...127
      var col = 0...7
      
      s.forEach {
        switch $0 {
        case "F":
          row = row.lowerBound...(row.lowerBound + row.count/2 - 1)
        case "B":
          row = (row.lowerBound + row.count/2)...row.upperBound
        case "L":
          col = col.lowerBound...(col.lowerBound + col.count/2 - 1)
        case "R":
          col = (col.lowerBound + col.count/2)...col.upperBound
        default:
          abort() // error
        }
      }
      
      // should probably check row and col to see if something went wrong, but it's AoC so let it fly
      return BoardingPass(row: row.first!, column: col.first!)
    }
  }
}

// ------------------------
// Doing a little redux on Day 5 solution now that I've had more time to ruminate on it.
// ------------------------

class Day5Redux: Day {
  /// What is the highest seat ID on a boarding pass?
  func part1() -> String {
    String(seatIDs().max()!)
  }
  
  /// Your seat wasn't at the very front or back, though; the seats with IDs +1 and -1 from yours will be in your list.
  /// What is the ID of your seat?
  func part2() -> String {
    let seatIDs = self.seatIDs()
    return String( (seatIDs.min()!...seatIDs.max()!).first { !seatIDs.contains($0) }! )
  }
  
  private func seatIDs() -> [Int] {
    input.replacingOccurrences(of: "F|L", with: "0", options: .regularExpression)
      .replacingOccurrences(of: "B|R", with: "1", options: .regularExpression)
      .lines()
      .compactMap { Int($0, radix: 2) }
  }
}
