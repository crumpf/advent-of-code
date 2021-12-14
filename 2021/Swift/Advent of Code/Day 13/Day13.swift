//
//  Day13.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day13: Day {
  func part1() -> String {
    let paper = TransparentPaper(input: input)
    let foldedOnce = foldDots(paper.dots, instruction: paper.instructions.first!)
    return "\(foldedOnce.count)"
  }
  
  func part2() -> String {
    let paper = TransparentPaper(input: input)
    var folded: Set<SIMD2<Int>> = paper.dots
    paper.instructions.forEach {
      folded = foldDots(folded, instruction: $0)
    }
    return printableCodeString(havingDots: folded)
  }
  
  func foldDots(_ dots: Set<SIMD2<Int>>, instruction: String) -> Set<SIMD2<Int>> {
    let parts = instruction.components(separatedBy: "=")
    let isUp = parts[0].last == "y"
    guard let value = Int(parts[1]) else {
      return []
    }
    
    var foldedDots: Set<SIMD2<Int>> = []
    if isUp {
      for d in dots {
        if d.y > value {
          foldedDots.insert(SIMD2(x: d.x, y: value - (d.y - value)))
        } else if d.y < value {
          foldedDots.insert(d)
        }
      }
    } else {
      for d in dots {
        if d.x > value {
          foldedDots.insert(SIMD2(x: value - (d.x - value), y: d.y))
        } else if d.x < value {
          foldedDots.insert(d)
        }
      }
    }
    return foldedDots
  }
  
  func printableCodeString(havingDots dots: Set<SIMD2<Int>>) -> String {
    let sortedX = dots.sorted { $0.x < $1.x }
    let sortedY = dots.sorted { $0.y < $1.y }
    var str = ""
    guard let firstX = sortedX.first?.x,
          let lastX = sortedX.last?.x,
          let firstY = sortedY.first?.y,
          let lastY = sortedY.last?.y
    else {
      return str
    }
    
    for y in firstY...lastY {
      for x in firstX...lastX {
        str.append(dots.contains(SIMD2(x: x, y: y)) ? "#" : ".")
      }
      str.append("\n")
    }
    return str
  }
}

struct TransparentPaper {
  let dots: Set<SIMD2<Int>>
  let instructions: [String]
  
  init(input: String) {
    let parts = input.components(separatedBy: "\n\n")
    dots = Set(parts[0].lines().compactMap {
      let coords = $0.components(separatedBy: ",")
      return SIMD2(x: Int(coords[0])!, y: Int(coords[1])!)
    })
    instructions = parts[1].lines()
  }
}
