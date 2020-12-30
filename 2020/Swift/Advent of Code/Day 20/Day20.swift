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

enum Direction {
  case above
  case below
  case left
  case right
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
    initialBitmap = lines.map { Array($0[1..<($0.count-1)]) }
    guard initialBitmap.count == initialBitmap[0].count else { return nil } // must be a square image
    orientation = .initial0
    border = initialBorder
  }
  
  func hash(into hasher: inout Hasher) { hasher.combine(id) }
  static func == (lhs: ImageTile, rhs: ImageTile) -> Bool { lhs.id == rhs.id }
  
  let id: Int
  private let initialBorder: Border
  let initialBitmap: [[Character]]
  var rowCount: Int { initialBitmap.count }
  var colCount: Int { initialBitmap.isEmpty ? 0 : initialBitmap[0].count }
  var orientation: Orientation {
    didSet {
      border = initialBorder.makeBorder(orientation: orientation)
    }
  }
  private(set) var border: Border
  
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
          if mostMatchesFound > 2 { break }
        }
        if mostMatchesFound > 2 { break }
      }
      if mostMatchesFound == 2 {
        corners.append(t1)
      }
    }
    
    return String(corners.reduce(1) { $0 * $1.id })
  }
  
  func part2() -> String {
    let tiles = makeTiles()
    let gridSize = Int(sqrt(Double(tiles.count)))
    var corners: [ImageTile] = []
    var edges: [ImageTile] = []
    
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
          if mostMatchesFound > 3 { break }
        }
        if mostMatchesFound > 3 { break }
      }
      if mostMatchesFound == 2 {
        corners.append(t1)
      } else if mostMatchesFound == 3 {
        edges.append(t1)
      }
    }
    
    // start by picking a corner
    var col: [ImageTile] = [corners.first!] // build a column (could be left or right edge of the final image)
    corners.removeFirst()
    
    for orient in Orientation.allCases {
      col[0].orientation = orient
      if let tile = tile(.below, of: col[0], candidates: edges) {
        edges.remove(at: edges.firstIndex(of: tile)!)
        col.append(tile)
        break
      }
    }
    
    while col.count < gridSize - 1  {
      if let tile = tile(.below, of: col.last!, candidates: edges) {
        edges.remove(at: edges.firstIndex(of: tile)!)
        col.append(tile)
      }
    }
    
    if let tile = tile(.below, of: col.last!, candidates: corners) {
      corners.remove(at: corners.firstIndex(of: tile)!)
      col.append(tile)
    }
    
    // now, build the top row
    var dir: Direction = .right
    edges.append(contentsOf: corners)
    
    var row: [ImageTile] = [col.first!]
    while row.count < gridSize {
      if let tile = tile(dir, of: dir == .right ? row.last! : row.first!, candidates: edges) {
        edges.remove(at: edges.firstIndex(of: tile)!)
        dir == .right ? row.append(tile) : row.insert(tile, at: 0)
      } else {
        dir = .left
      }
    }
    
    // with a completed edge and top row, lets go through the rest of the tiles and try to fit them in place
    var tileRows: [[ImageTile]] = [row]
    var ignore: [Int] = row.map { $0.id } + col.map { $0.id}
    
    var currentRow = 1
    while currentRow < gridSize {
      row = [col[currentRow]]
      while row.count < gridSize {
        var badMatches: [Int] = []
        let col = dir == .right ? row.count : (gridSize - 1) - row.count
        if let tile = tile(dir, of: dir == .right ? row.last! : row.first!, candidates: tiles, ignoreIds: ignore + badMatches) {
          let tileAbove = tileRows[currentRow-1][col]
          if tileAbove.border.bottom == tile.border.top {
            ignore.append(tile.id)
            dir == .right ? row.append(tile) : row.insert(tile, at: 0)
          } else {
            badMatches.append(tile.id)
          }
        }
      }
      tileRows.append(row)
      currentRow += 1
    }
    
    var image = [[Character]]()
    tileRows.forEach { tileRow in
      let reducedMap = tileRow.reduce(Array(repeating: [Character](), count: tileRow[0].rowCount)) { (map, imageTile) in
        zip(map, makeBitmap(orientation: imageTile.orientation, source: imageTile.initialBitmap)).map {
          $0.0 + $0.1
        }
      }
      image.append(contentsOf: reducedMap)
    }
    
    var seaMonsters = 0
    
    for _ in (0...3) {
      seaMonsters = seaMonsterCount(in: image)
      if seaMonsters > 0 {
        break
      } else {
        image = makeBitmap(orientation: .initial90, source: image)
      }
    }
    
    if seaMonsters == 0 {
      image = makeBitmap(orientation: .flipped0, source: image)
      for _ in (0...3) {
        seaMonsters = seaMonsterCount(in: image)
        if seaMonsters > 0 {
          break
        } else {
          image = makeBitmap(orientation: .initial90, source: image)
        }
      }
    }
    
    let waterRoughness = image.flatMap { $0 }.filter { $0 == "#" }.count - seaMonsters * 15
    return String(waterRoughness)
  }
  
  private func makeTiles() -> [ImageTile] {
    input.components(separatedBy: "\n\n").compactMap { ImageTile.init(data: $0) }
  }
  
  private func tile(_ direction: Direction, of tile: ImageTile, candidates: [ImageTile], ignoreIds: [Int] = []) -> ImageTile? {
    for candidate in candidates {
      if ignoreIds.contains(candidate.id) { continue }
      for orient in Orientation.allCases {
        candidate.orientation = orient
        switch direction {
        case .above where tile.border.top == candidate.border.bottom:
          return candidate
        case .below where tile.border.bottom == candidate.border.top:
          return candidate
        case .left where tile.border.left == candidate.border.right:
          return candidate
        case .right where tile.border.right == candidate.border.left:
          return candidate
        default:
          continue
        }
      }
    }
    return nil
  }
  
  func makeBitmap(orientation: Orientation, source: [[Character]]) -> [[Character]] {
    var bitmap = Array(repeating: [Character](), count: source.count)
    let maxIdx = source.count - 1
    switch orientation {
    case .initial0:
      return source
    case .initial90:
      bitmap.indices.forEach { i in
        bitmap[i] = source.compactMap { $0[maxIdx - i] }
      }
    case .initial180:
      bitmap.indices.forEach { i in
        bitmap[i] = source[maxIdx - i].reversed()
      }
    case .initial270:
      bitmap.indices.forEach { i in
        bitmap[i] = source.compactMap { $0[i] }.reversed()
      }
    case .flipped0:
      bitmap.indices.forEach { i in
        bitmap[i] = source[maxIdx - i]
      }
    case .flipped90:
      bitmap.indices.forEach { i in
        bitmap[i] = source.compactMap { $0[maxIdx - i] }.reversed()
      }
    case .flipped180:
      bitmap.indices.forEach { i in
        bitmap[i] = source[i].reversed()
      }
    case .flipped270:
      bitmap.indices.forEach { i in
        bitmap[i] = source.compactMap { $0[i] }
      }
    }
    return bitmap
  }
  
  private func seaMonsterCount(in map: [[Character]]) -> Int {
    var count = 0
    
    for y in 0..<(map.count - 3) {
      for x in 0..<(map[y].count - 20) {
        if map[y  ][x+18] == "#", map[y+1][x   ] == "#", map[y+1][x+5 ] == "#",
           map[y+1][x+6 ] == "#", map[y+1][x+11] == "#", map[y+1][x+12] == "#",
           map[y+1][x+17] == "#", map[y+1][x+18] == "#", map[y+1][x+19] == "#",
           map[y+2][x+1 ] == "#", map[y+2][x+4 ] == "#", map[y+2][x+7 ] == "#",
           map[y+2][x+10] == "#", map[y+2][x+13] == "#", map[y+2][x+16] == "#" {
          count += 1
        }
      }
    }
    
    return count
  }
  
}
