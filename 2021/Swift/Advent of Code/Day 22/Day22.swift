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
  
  // Starting with all cubes off, run all of the reboot steps for all cubes in the reactor.
  func part2() -> String {
    let result = executeRebootStepsAndFindAllOnCubes(rebootSteps: rebootInput)
    return "\(result)"
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
  
  func executeRebootStepsAndFindAllOnCubes(rebootSteps: [Cuboid]) -> Int {
    var onCuboids: [Cuboid] = []
    // everything starts in off state, so we can ignore any starting steps that are also off
    rebootSteps.drop { step in step.state == .off }
    .forEach { step in
      // See if the 'step' cuboid intersects with the running list of 'on' cuboids.
      // If there's an intersecton, new cuboid fragments are created by subtracting the
      // intersecting region. We discard the cuboid that was intersected in the list and add back
      // it's fragments.
      // Finally, if the 'step' cuboid is "on" state, we add it to the 'on' cuboids list.
      var additions: [Cuboid] = []
      var removals: [Cuboid] = []
      for c in onCuboids {
        if let intersect = intersectRanges(c.range, step.range) {
          additions += fragmentCuboidBySubtractingRegion(cuboid: c, region: intersect)
          removals.append(c)
        }
      }
      onCuboids.removeAll { removals.contains($0) }
      onCuboids += additions
      if step.state == .on {
        onCuboids.append(step)
      }
    }
    
    return onCuboids.reduce(0) { $0 + $1.cubeCount }
  }
  
  // Returns an array of Cuboids that represent the subtraction of region from cuboid.region.
  func fragmentCuboidBySubtractingRegion(cuboid: Cuboid, region: Range3D) -> [Cuboid] {
    guard areRangesOverlapping(cuboid.range, region) else {
      return [cuboid]
    }
    var fragments: [Cuboid] = []
    if cuboid.range.z.upperBound > region.z.upperBound {
      let r = Range3D(cuboid.range.x, cuboid.range.y, (region.z.upperBound+1)...cuboid.range.z.upperBound)
      fragments.append(Cuboid(range: r, state: cuboid.state))
    }
    if cuboid.range.z.lowerBound < region.z.lowerBound {
      let r = Range3D(cuboid.range.x, cuboid.range.y, cuboid.range.z.lowerBound...(region.z.lowerBound-1))
      fragments.append(Cuboid(range: r, state: cuboid.state))
    }
    if cuboid.range.y.upperBound > region.y.upperBound {
      let r = Range3D(cuboid.range.x,
                      (region.y.upperBound+1)...cuboid.range.y.upperBound,
                      max(cuboid.range.z.lowerBound, region.z.lowerBound)...min(cuboid.range.z.upperBound, region.z.upperBound))
      fragments.append(Cuboid(range: r, state: cuboid.state))
    }
    if cuboid.range.y.lowerBound < region.y.lowerBound {
      let r = Range3D(cuboid.range.x,
                      cuboid.range.y.lowerBound...(region.y.lowerBound-1),
                      max(cuboid.range.z.lowerBound, region.z.lowerBound)...min(cuboid.range.z.upperBound, region.z.upperBound))
      fragments.append(Cuboid(range: r, state: cuboid.state))
    }
    if cuboid.range.x.upperBound > region.x.upperBound {
      let r = Range3D((region.x.upperBound+1)...cuboid.range.x.upperBound,
                      max(cuboid.range.y.lowerBound, region.y.lowerBound)...min(cuboid.range.y.upperBound, region.y.upperBound),
                      max(cuboid.range.z.lowerBound, region.z.lowerBound)...min(cuboid.range.z.upperBound, region.z.upperBound))
      let c = Cuboid(range: r, state: cuboid.state)
      fragments.append(c)
    }
    if cuboid.range.x.lowerBound < region.x.lowerBound {
      let r = Range3D(cuboid.range.x.lowerBound...(region.x.lowerBound-1),
                      max(cuboid.range.y.lowerBound, region.y.lowerBound)...min(cuboid.range.y.upperBound, region.y.upperBound),
                      max(cuboid.range.z.lowerBound, region.z.lowerBound)...min(cuboid.range.z.upperBound, region.z.upperBound))
      let c = Cuboid(range: r, state: cuboid.state)
      fragments.append(c)
    }
    return fragments
  }
  
  func areRangesOverlapping(_ a: Range3D, _ b: Range3D) -> Bool {
    a.x.overlaps(b.x) && a.y.overlaps(b.y) && a.z.overlaps(b.z)
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
  
  struct Cuboid: Equatable {
    static func == (lhs: Day22.Cuboid, rhs: Day22.Cuboid) -> Bool {
      lhs.state == rhs.state && lhs.range == rhs.range
    }
    
    let range: Range3D
    let state: State
    
    var cubeCount: Int {
      range.x.count * range.y.count * range.z.count
    }
    
    enum State: String {
      case off, on
    }
  }
  
}
