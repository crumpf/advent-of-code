//
//  main.swift
//  AoC2019 Day 6
//
//  Created by Christopher Rumpf on 12/16/19.
//

import Foundation

print("Advent of Code 2019, Day 6")

let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)

let input = try? String(contentsOf: fileURL)

class Body {
  let name: String
  
  weak var orbiting: Body? = nil
  var orbitedBy: [String: Body] = [:]
  
  init(name: String) {
    self.name = name
  }
  
  func numberOfOrbits() -> Int {
    if let orbiting = orbiting {
      return 1 + orbiting.numberOfOrbits()
    }
    return 0
  }
  
  func pathToCOM() -> [Body] {
    if let orbiting = orbiting {
      return [orbiting] + orbiting.pathToCOM()
    }
    return []
  }
}

class OrbitsMap {
  private var bodies: [String: Body] = [:]
  
  var count: Int {
    bodies.count
  }
  
  func add(name: String, orbitedBy: String) {
    var body = bodies[name]
    var satellite = bodies[orbitedBy]
    
    if let b = body, let s = satellite, b.orbitedBy[s.name] != nil {
      print("Error: these bodies already have relationship: \(name))\(orbitedBy)")
      return
    }
    
    if body == nil {
      body = Body(name: name)
      bodies[body!.name] = body
    }
    if satellite == nil {
      satellite = Body(name: orbitedBy)
      bodies[satellite!.name] = satellite
    }
    
    if let b = body, let s = satellite {
      b.orbitedBy[s.name] = s
      s.orbiting = b
    }
  }
  
  func numberOfOrbits(bodyName: String) -> Int {
    guard let body = bodies[bodyName] else {
      return 0
    }
    
    return body.numberOfOrbits()
  }
  
  func numberOfOrbits() -> Int {
    var total = 0
    for body in bodies.values {
      total += body.numberOfOrbits()
    }
    return total
  }
  
  func numberOfOrbits(from: String, to: String) -> Int {
    guard let fromBody = bodies[from], let toBody = bodies[to] else {
      return 0
    }
    
    var fromPath: [Body] = fromBody.pathToCOM().reversed()
    var toPath: [Body] = toBody.pathToCOM().reversed()
    
    var commonOrbitIndex = -1
    for i in 0..<min(fromPath.count, toPath.count) {
      if fromPath[i].name != toPath[i].name {
        break
      }
      commonOrbitIndex = i
    }
    
    if commonOrbitIndex < 0 {
      return 0
    }
    
    fromPath.removeFirst(commonOrbitIndex)
    toPath.removeFirst(commonOrbitIndex)
    
    return fromPath.count + toPath.count - 2
  }
}

let orbits = OrbitsMap()

if let relationships = input?.components(separatedBy: "\n") {
  for relationship in relationships {
    let bodies = relationship.components(separatedBy: ")")
    if bodies.count != 2 {
      print("Error found with relationship format: \(relationship)")
      break
    }
    orbits.add(name: bodies[0], orbitedBy: bodies[1])
  }
}

print("total orbits: \(orbits.numberOfOrbits())")

// PART 2

print("YOU: \(orbits.numberOfOrbits(bodyName: "YOU"))")
print("SAN: \(orbits.numberOfOrbits(bodyName: "SAN"))")

print("YOU to SAN: \(orbits.numberOfOrbits(from: "YOU", to: "SAN"))")
