//
//  Day22.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day22: Day {
  // Execute the reboot steps. Afterward, considering only cubes in the region "x=-50..50,y=-50..50,z=-50..50", how many cubes are on?
  func part1() -> String {
    let searchRegion = Day22.makeRange3D(fromString: "x=-50..50,y=-50..50,z=-50..50")!
    let result = executeRebootStepsAndFindOnCubes(rebootSteps: rebootInput, region: searchRegion)
    
    return "\(result)"
  }
  
  func part2() -> String {
    return ""
  }
  
  let rebootInput: [Cuboid]
  
  override init(input: String) {
    self.rebootInput = input.lines().compactMap { line in
      let parts = line.components(separatedBy: .whitespaces)
      guard let state = Cuboid.State(rawValue: parts[0]),
            let range = Day22.makeRange3D(fromString: parts[1]) else {
        return nil
      }
      return Cuboid(range: range, state: state)
    }
    
    super.init(input: input)
  }
  
  private static func makeRange3D(fromString str: String) -> Range3D? {
    let xyz = str.components(separatedBy: ",")
    guard xyz.count == 3,
          xyz[0].first == "x", let x = makeClosedRange(fromString: String(xyz[0].dropFirst(2))),
          xyz[1].first == "y", let y = makeClosedRange(fromString: String(xyz[1].dropFirst(2))),
          xyz[2].first == "z", let z = makeClosedRange(fromString: String(xyz[2].dropFirst(2)))
    else {
      return nil
    }
    return Range3D(x, y, z)
  }
  
  private static func makeClosedRange(fromString str: String) -> ClosedRange<Int>? {
    let parts = str.components(separatedBy: "..")
    guard parts.count == 2,
          let min = Int(parts[0]),
          let max = Int(parts[1]),
          min <= max
    else {
      return nil
    }
    return min...max
  }
  
  func executeRebootStepsAndFindOnCubes(rebootSteps: [Cuboid], region: Range3D) -> Int {
    var onCubes: Set<SIMD3<Int>> = []
    // everything starts in off state, so we can ignore any starting steps that are also off
    rebootSteps.drop { step in step.state == .off }
    .forEach { step in
      // does this fall within the region we're concerned about?
      if let intersect = intersectRanges(region, step.range) {
        for z in intersect.z {
          for y in intersect.y {
            for x in intersect.x {
              let c = SIMD3(x, y, z)
              if step.state == .on {
                onCubes.insert(c)
              } else {
                onCubes.remove(c)
              }
            }
          }
        }
      }
    }
    return onCubes.count
  }
  
  typealias Range3D = (x: ClosedRange<Int>, y: ClosedRange<Int>, z: ClosedRange<Int>)
  
  func intersectRanges(_ a: Range3D, _ b: Range3D) -> Range3D? {
    var intersect = Range3D(x:0...0, y:0...0, z:0...0)
    
    if a.x.overlaps(b.x) {
      intersect.x = (max(a.x.lowerBound, b.x.lowerBound))...(min(a.x.upperBound, b.x.upperBound))
    } else {
      return nil
    }
    if a.y.overlaps(b.y) {
      intersect.y = (max(a.y.lowerBound, b.y.lowerBound))...(min(a.y.upperBound, b.y.upperBound))
    } else {
      return nil
    }
    if a.z.overlaps(b.z) {
      intersect.z = (max(a.z.lowerBound, b.z.lowerBound))...(min(a.z.upperBound, b.z.upperBound))
    } else {
      return nil
    }
    return intersect
  }
  
  struct Cuboid {
    let range: Range3D
    let state: State
    
    enum State: String {
      case off, on
    }
  }
  
}
