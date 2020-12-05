//
//  main.swift
//  Day 5
//
//  Created by Christopher Rumpf on 12/3/20.
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

class Day5 {
  func makeBoardingPasses(input: String) -> [BoardingPass] {
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

extension Day5: Puzzle {
  func part1(withInput input: String) -> String {
    String(describing: makeBoardingPasses(input: input).map { $0.seatID }.max())
  }
  
  func part2(withInput input: String) -> String {
    let boardingPasses = self.makeBoardingPasses(input: input).sorted { $0.seatID < $1.seatID }
    
    var mySeatID = -1
    for (index, pass) in boardingPasses.enumerated() {
      if pass.seatID - index != boardingPasses.first!.seatID {
        mySeatID = pass.seatID - 1
        break
      }
    }
    
    return String(mySeatID)
  }
}

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day5()

print("====Tests====")
print(day.makeBoardingPasses(input: "FBFBBFFRLR").first!.seatID == 357)
print(day.makeBoardingPasses(input: "BFFFBBFRRR").first!.seatID == 567)
print(day.makeBoardingPasses(input: "FFFBBBFRRR").first!.seatID == 119)
print(day.makeBoardingPasses(input: "BBFFBBFRLL").first!.seatID == 820)

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.raw)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.raw)
print(part2)
