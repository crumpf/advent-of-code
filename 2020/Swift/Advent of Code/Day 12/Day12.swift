//
//  Day12.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day12: Day {
  /// Figure out where the navigation instructions lead. What is the Manhattan distance between that location and the ship's starting position?
  func part1() -> String {
    var facing = 0
    var location = SIMD2(0, 0)
    let instructions = input.lines().map { inst -> (Character, Int) in
      return (inst.first!, Int(inst.suffix(inst.count-1))!)
    }
    
    instructions.forEach { (inst) in
      switch inst.0 {
      case "N":
        location.y += inst.1
      case "S":
        location.y -= inst.1
      case "E":
        location.x += inst.1
      case "W":
        location.x -= inst.1
      case "L":
        facing = (facing + inst.1) % 360
      case "R":
        facing = (facing - inst.1) % 360
      case "F":
        switch facing {
        case 90, -270:
          location.y += inst.1
        case 270, -90:
          location.y -= inst.1
        case 0:
          location.x += inst.1
        case 180, -180:
          location.x -= inst.1
        default:
          break
        }
      default:
        break
      }
    }
    
    return String(abs(location.x) + abs(location.y))
  }

  /// Figure out where the navigation instructions actually lead. What is the Manhattan distance between that location and the ship's starting position?
  func part2() -> String {
    var location = SIMD2(0, 0)
    var waypoint = SIMD2(10, 1)
    let instructions = input.lines().map { inst -> (Character, Int) in
      return (inst.first!, Int(inst.suffix(inst.count-1))!)
    }
    
    instructions.forEach { (inst) in
      switch inst.0 {
      case "N":
        waypoint.y += inst.1
      case "S":
        waypoint.y -= inst.1
      case "E":
        waypoint.x += inst.1
      case "W":
        waypoint.x -= inst.1
      case "L":
        let rads = Float(inst.1) * (Float.pi/180.0)
        waypoint = SIMD2(waypoint.x * Int(cos(rads)) - waypoint.y * Int(sin(rads)),
                         waypoint.x * Int(sin(rads)) + waypoint.y * Int(cos(rads)))
      case "R":
        let rads = -1.0*Float(inst.1) * (Float.pi/180.0)
        waypoint = SIMD2(waypoint.x * Int(cos(rads)) - waypoint.y * Int(sin(rads)),
                         waypoint.x * Int(sin(rads)) + waypoint.y * Int(cos(rads)))
      case "F":
        location = location &+ SIMD2(inst.1 * waypoint.x, inst.1 * waypoint.y)
      default:
        break
      }
    }
    
    return String(abs(location.x) + abs(location.y))
  }
}
