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

struct Border {
  let top, left, bottom, right: String
  func makeBorder(orientation: Orientation) -> Border {
    switch orientation {
    case .initial0:
      return self
    case .initial90:
      return Border(top: right, left: String(top.reversed()), bottom: left, right: String(bottom.reversed()))
    case .initial180:
      return Border(top: String(bottom.reversed()), left: String(right.reversed()), bottom: String(top.reversed()), right: String(left.reversed()))
    case .initial270:
      return Border(top: String(left.reversed()), left: bottom, bottom: String(right.reversed()), right: top)
    case .flipped0:
      return Border(top: bottom, left: String(left.reversed()), bottom: top, right: String(right.reversed()))
    case .flipped90:
      return Border(top: String(right.reversed()), left: String(bottom.reversed()), bottom: String(left.reversed()), right: String(top.reversed()))
    case .flipped180:
      return Border(top: String(top.reversed()), left: right, bottom: String(bottom.reversed()), right: left)
    case .flipped270:
      return Border(top: left, left: top, bottom: right, right: bottom)
    }
  }
}

class ImageTile: Hashable {
  init?(data: String) {
    let components = data.components(separatedBy: ":\n")
    guard components.count >= 2,
          let id = Int(components[0].dropFirst("Tile ".count))
    else {
      return nil
    }
    var lines = components[1].lines()
    
    self.id = id
    let left = String(lines.compactMap { $0.first })
    let right = String(lines.compactMap { $0.last })
    let top = lines.removeFirst()
    let bottom = lines.removeLast()
    initialBorder = Border(top: top, left: left, bottom: bottom, right: right)
    initialBitmap = lines.map { String($0[1..<($0.count-1)]) }
    guard initialBitmap.count == initialBitmap[0].count else { return nil } // must be a square image
    orientation = .initial0
    border = initialBorder
  }
  
  func hash(into hasher: inout Hasher) { hasher.combine(id) }
  static func == (lhs: ImageTile, rhs: ImageTile) -> Bool { lhs.id == rhs.id }
  
  let id: Int
  private let initialBorder: Border
  private let initialBitmap: [String]
  var rowCount: Int { initialBitmap.count }
  var colCount: Int { initialBitmap.isEmpty ? 0 : initialBitmap[0].count }
  var orientation: Orientation {
    didSet {
      border = initialBorder.makeBorder(orientation: orientation)
    }
  }
  private(set) var border: Border
  var topTile: ImageTile?
  var leftTile: ImageTile?
  var bottomTile: ImageTile?
  var rightTile: ImageTile?
  
  func makeBitmap() -> [String] {
    var bitmap = [String]()
    let maxIdx = rowCount - 1
    switch orientation {
    case .initial0:
      return initialBitmap
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
    return bitmap
  }
  
  func printData() {
    print("Tile \(id): \(orientation)")
    makeBitmap().forEach { print($0) }
  }
}

class Day20: Day {
  
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
            if t1.border.left == t2.border.right { matches += 1 }
            else if t1.border.right == t2.border.left { matches += 1 }
            else if t1.border.top == t2.border.bottom { matches += 1 }
            else if t1.border.bottom == t2.border.top { matches += 1 }
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
