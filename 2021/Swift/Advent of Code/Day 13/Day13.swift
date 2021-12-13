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
    let result = paper.execute(maxFolds: 1)
    return "\(result.count)"
  }
  
  func part2() -> String {
    let paper = TransparentPaper(input: input)
    let result = paper.execute()
    printDots(result)
    return ""
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
  
  func execute(maxFolds: Int = Int.max) -> Set<SIMD2<Int>> {
    var foldedDots: Set<SIMD2<Int>> = dots
    var numberOfFolds = 0
    for inst in instructions {
      if numberOfFolds < maxFolds {
        numberOfFolds += 1
      } else {
        break
      }
      let parts = inst.components(separatedBy: "=")
      let isUp = parts[0].last == "y"
      let value = Int(parts[1])!
      var foldedDotsForInstruction: Set<SIMD2<Int>> = []
      if isUp {
        foldedDots.forEach { d in
          if d.y > value {
            foldedDotsForInstruction.insert(SIMD2(x: d.x, y: value - (d.y - value)))
          } else if d.y < value {
            foldedDotsForInstruction.insert(d)
          }
        }
      } else {
        foldedDots.forEach { d in
          if d.x > value {
            foldedDotsForInstruction.insert(SIMD2(x: value - (d.x - value), y: d.y))
          } else if d.x < value {
            foldedDotsForInstruction.insert(d)
          }
        }
      }
      foldedDots = foldedDotsForInstruction
      
//      print(inst)
//      printDots(foldedDots)
    }
    return foldedDots
  }
}

func printDots(_ dots: Set<SIMD2<Int>>) {
  let sortedX = dots.sorted { $0.x < $1.x }
  let sortedY = dots.sorted { $0.y < $1.y }
  let rangeX = sortedX.first!.x...sortedX.last!.x
  let rangeY = sortedY.first!.y...sortedY.last!.y
  for y in rangeY {
    var line = ""
    for x in rangeX {
      line.append(dots.contains(SIMD2(x: x, y: y)) ? "#" : ".")
    }
    print(line)
  }
}
