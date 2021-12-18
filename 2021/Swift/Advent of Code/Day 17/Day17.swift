//
//  Day17.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day17: Day {
  func part1() -> String {
    let target = makeTarget()
    let highest = highestYThatHits(target)
    if let result = highest?.highestY {
      print("found highest: " + String(describing: highest))
      return "\(result)"
    }
    return "no hits"
  }
  
  func part2() -> String {
    return ""
  }
  
  func makeTarget() -> Target {
    // input format of form:
    // "target area: x=20..30, y=-10..-5"
    let parts = input.trimmingCharacters(in: .whitespacesAndNewlines)
      .drop { !$0.isNumber }
      .components(separatedBy: ", y=")
    let xParts = parts[0].components(separatedBy: "..")
    let yParts = parts[1].components(separatedBy: "..")
    return Target(xRange: Int(xParts[0])!...Int(xParts[1])!,
                  yRange: Int(yParts[0])!...Int(yParts[1])!)
  }
  
  typealias HighestY = (highestY: Int, velocity: SIMD2<Int>)
  
  func highestYThatHits(_ target: Target) -> HighestY? {
    var highest: HighestY? = nil
    // should probaby optimize these ranges, but we'll just knuckle-drag it for now
    for x in 1...200 {
      for y in 1...200 {
        var probe = Probe(position: SIMD2.zero, velocity: SIMD2(x, y))
        var maxY = Int.min
        var relation = probe.relation(relativeTo: target)
        while relation == .beforeTarget {
          probe = probe.step()
          if probe.position.y > maxY {
            maxY = probe.position.y
          }
          relation = probe.relation(relativeTo: target)
        }
        if relation == .insideTarget {
          if highest == nil || maxY > highest!.highestY {
            highest = (maxY, SIMD2(x, y))
          }
        }
      }
    }
    return highest
  }
  
  struct Target {
    let xRange: ClosedRange<Int>
    let yRange: ClosedRange<Int>
  }
  
  struct Probe {
    let position: SIMD2<Int>
    let velocity: SIMD2<Int>
    
    func step() -> Probe {
      let pos = position &+ velocity
      var velX = velocity.x
      if velX > 0 {
        velX -= 1
      } else if velX < 0 {
        velX += 1
      }
      return Probe(position: pos, velocity: SIMD2(velX, velocity.y - 1))
    }
    
    func relation(relativeTo target: Target) -> ProbeRelation {
      guard position.y >= target.yRange.min()! else {
        return .beyondTarget
      }
      if target.xRange.contains(position.x) && target.yRange.contains(position.y) {
        return .insideTarget
      }
      return .beforeTarget
    }
  }
  
  enum ProbeRelation {
    case beforeTarget, insideTarget, beyondTarget
  }
}

