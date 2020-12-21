//
//  Day20.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

enum Orientation: CaseIterable {
  case initial0
  case initial90
  case initial180
  case initial270
  case flipped0
  case flipped90
  case flipped180
  case flipped270
}

class ImageTile: Hashable {
  init?(data: String) {
    let components = data.components(separatedBy: ":\n")
    guard components.count >= 2,
          let id = Int(components[0].dropFirst("Tile ".count))
    else {
      return nil
      
    }
    self.id = id
    self.initialBitmap = components[1].lines()
    guard initialBitmap.count == initialBitmap[0].count else { return nil } // must be a square image
    orientation = .initial0
    bitmap = initialBitmap
  }
  
  func hash(into hasher: inout Hasher) { hasher.combine(id) }
  static func == (lhs: ImageTile, rhs: ImageTile) -> Bool { lhs.id == rhs.id }
  
  let id: Int
  private let initialBitmap: [String]
  private(set) var bitmap: [String]
  var rowCount: Int { bitmap.count }
  var colCount: Int { bitmap.isEmpty ? 0 : bitmap[0].count }
  var orientation: Orientation {
    didSet {
      let maxIdx = rowCount - 1
      switch orientation {
      case .initial0:
        bitmap = initialBitmap
      case .initial90:
        bitmap.indices.forEach { i in
          bitmap[i] = String(initialBitmap.compactMap { $0[maxIdx - i] })
        }
      case .initial180:
        bitmap.indices.forEach { i in
          bitmap[i] = String(initialBitmap[maxIdx - i].reversed())
        }
      case .initial270:
        bitmap.indices.forEach { i in
          bitmap[i] = String(initialBitmap.compactMap { $0[i] }.reversed())
        }
      case .flipped0:
        bitmap.indices.forEach { i in
          bitmap[i] = initialBitmap[maxIdx - i]
        }
      case .flipped90:
        bitmap.indices.forEach { i in
          bitmap[i] = String(initialBitmap.compactMap { $0[maxIdx - i] }.reversed())
        }
      case .flipped180:
        bitmap.indices.forEach { i in
          bitmap[i] = String(initialBitmap[i].reversed())
        }
      case .flipped270:
        bitmap.indices.forEach { i in
          bitmap[i] = String(initialBitmap.compactMap { $0[i] })
        }
      }
    }
  }
  var topEdge: String { bitmap.first! }
  var leftEdge: String { String(bitmap.compactMap { $0.first }) }
  var bottomEdge: String { bitmap.last! }
  var rightEdge: String { String(bitmap.compactMap { $0.last }) }
  var topTile: ImageTile?
  var leftTile: ImageTile?
  var bottomTile: ImageTile?
  var rightTile: ImageTile?
  
  
  func printData() {
    print("Tile \(id): \(orientation)")
    bitmap.forEach { print($0) }
  }
}

class Day20: Day {
  
  /*
   A few notes about this pt 1 solution. It takes around 30 seconds with the puzzle input to flip all the pieces around and do all the comparisons in the way I approached it. Painfully slow.
   I should optimize and calculate the edge values and compare the tiles based on those instead of all repeated orientation changes in the algorithm below checking for matches causing underlying bitmap changes. But, I've been banging away at this puzzle for so long I'm just happy to have found the answer correct answer. Maybe one day I'll tackle this again.
   */
  
  /// To check that you've assembled the image correctly, multiply the IDs of the four corner tiles together.
  func part1() -> String {
    let tiles = makeTiles()
    var corners: [ImageTile] = []
    
    // for each tile, see if in every orientation it has a max number of matches of 2. Those are probably our corner pieces.
    tiles.forEach { t1 in
      var mostMatchesFound = 0
      for o1 in Orientation.allCases {
        t1.orientation = o1
        var matches = 0
        for t2 in tiles {
          if t1 == t2 { continue }
          for o2 in Orientation.allCases {
            t2.orientation = o2
            if t1.leftEdge == t2.rightEdge { matches += 1 }
            else if t1.rightEdge == t2.leftEdge { matches += 1 }
            else if t1.topEdge == t2.bottomEdge { matches += 1 }
            else if t1.bottomEdge == t2.topEdge { matches += 1 }
          }
          if matches > mostMatchesFound { mostMatchesFound = matches }
        }
      }
      if mostMatchesFound == 2 {
        corners.append(t1)
      }
    }
    
    return String(corners.reduce(1) { $0 * $1.id })
  }
  
  func part2() -> String {
    "Not Implemented"
  }
  
  private func makeTiles() -> [ImageTile] {
    input.components(separatedBy: "\n\n").compactMap { ImageTile.init(data: $0) }
  }
}
