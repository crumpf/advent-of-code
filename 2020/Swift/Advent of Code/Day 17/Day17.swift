//
//  Day17.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

extension SIMD3 where Scalar == Int {
  func neighborsActive(cubes: [SIMD3<Int>: Character]) -> Int {
    var count = 0
    ((z-1)...(z+1)).forEach { z in
      ((y-1)...(y+1)).forEach { y in
        ((x-1)...(x+1)).forEach { x in
          let xyz = SIMD3(x, y, z)
          if xyz != self, let status = cubes[xyz], status == "#" {
            count += 1
          }
        }
      }
    }
    return count
  }
}

extension SIMD4 where Scalar == Int {
  func neighborsActive(cubes: [SIMD4<Int>: Character]) -> Int {
    var count = 0
    ((w-1)...(w+1)).forEach { w in
      ((z-1)...(z+1)).forEach { z in
        ((y-1)...(y+1)).forEach { y in
          ((x-1)...(x+1)).forEach { x in
            let loc = SIMD4(x, y, z, w)
            if loc != self, let status = cubes[loc], status == "#" {
              count += 1
            }
          }
        }
      }
    }
    return count
  }
}

struct Region<T> {
  let min, max: T
}

class Day17: Day {
  /// Starting with your given initial configuration, simulate six cycles. How many cubes are left in the active state after the sixth cycle?
  func part1() -> String {
    let lines = input.lines()
    var cubes: [SIMD3<Int>: Character] = [:]
    lines.enumerated().forEach { (y, line) in
      line.enumerated().forEach { (x, state) in
        cubes[SIMD3(x, y, 0)] = state
      }
    }
    
    var region = Region(min: SIMD3.zero, max: SIMD3(lines[0].count-1, lines[0].count-1, 0))
    
    (1...6).forEach { _ in
      region = Region(min: region.min &- SIMD3.one,
                      max: region.max &+ SIMD3.one)
      cubes = cycle(cubes: cubes, in: region)
    }
    
    return String(cubes.filter { $0.value == "#" }.count)
  }
  
  /// Starting with your given initial configuration, simulate six cycles in a 4-dimensional space. How many cubes are left in the active state after the sixth cycle?
  func part2() -> String {
    let lines = input.lines()
    var cubes: [SIMD4<Int>: Character] = [:]
    lines.enumerated().forEach { (y, line) in
      line.enumerated().forEach { (x, state) in
        cubes[SIMD4(x, y, 0, 0)] = state
      }
    }
    
    var region = Region(min: SIMD4.zero, max: SIMD4(lines[0].count-1, lines[0].count-1, 0, 0))
    
    (1...6).forEach { _ in
      region = Region(min: region.min &- SIMD4.one,
                      max: region.max &+ SIMD4.one)
      cubes = cycle(cubes: cubes, in: region)
    }
    
    return String(cubes.filter { $0.value == "#" }.count)
  }
  
  /**
   During a cycle, all cubes simultaneously change their state according to the following rules:

   - If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
   - If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.
   */
  private func cycle(cubes: [SIMD3<Int>: Character], in region: Region<SIMD3<Int>>) -> [SIMD3<Int>: Character] {
    var newCubes = cubes
    (region.min.z...region.max.z).forEach { z in
      (region.min.y...region.max.y).forEach { y in
        (region.min.x...region.max.x).forEach { x in
          let coordinate = SIMD3(x, y, z)
          let status = cubes[coordinate] ?? "."
          let neighborActiveCount = coordinate.neighborsActive(cubes: cubes)
          if status == "#" && !(2...3).contains(neighborActiveCount) {
            newCubes[coordinate] = "."
          } else if status == "." && neighborActiveCount == 3 {
            newCubes[coordinate] = "#"
          }
        }
      }
    }
    return newCubes
  }
  
  private func cycle(cubes: [SIMD4<Int>: Character], in region: Region<SIMD4<Int>>) -> [SIMD4<Int>: Character] {
    var newCubes = cubes
    (region.min.w...region.max.w).forEach { w in
      (region.min.z...region.max.z).forEach { z in
        (region.min.y...region.max.y).forEach { y in
          (region.min.x...region.max.x).forEach { x in
            let coordinate = SIMD4(x, y, z, w)
            let status = cubes[coordinate] ?? "."
            let neighborActiveCount = coordinate.neighborsActive(cubes: cubes)
            if status == "#" && !(2...3).contains(neighborActiveCount) {
              newCubes[coordinate] = "."
            } else if status == "." && neighborActiveCount == 3 {
              newCubes[coordinate] = "#"
            }
          }
        }
      }
    }
    return newCubes
  }
}

