//
//  GridLocation.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/21.
//

struct GridLocation: Hashable {
  let row: Int
  let col: Int
  
  func orthogonal() -> [GridLocation]  {
      [GridLocation(row: row-1, col: col),
       GridLocation(row: row,   col: col+1),
       GridLocation(row: row+1, col: col),
       GridLocation(row: row,   col: col-1)]
  }
  
  func surrounding() -> [GridLocation] {
    [GridLocation(row: row-1, col: col-1),
     GridLocation(row: row-1, col: col),
     GridLocation(row: row-1, col: col+1),
     GridLocation(row: row,   col: col-1),
     GridLocation(row: row,   col: col),
     GridLocation(row: row,   col: col+1),
     GridLocation(row: row+1, col: col-1),
     GridLocation(row: row+1, col: col),
     GridLocation(row: row+1, col: col+1)]
  }
}
