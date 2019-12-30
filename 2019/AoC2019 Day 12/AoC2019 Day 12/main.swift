//
//  main.swift
//  AoC2019 Day 12
//
//  Created by Chris Rumpf on 12/30/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

import Foundation

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

// Day 12: The N-Body Problem

//Each moon has a 3-dimensional position (x, y, and z) and a 3-dimensional velocity
struct Moon: Hashable {
    var position: SIMD3<Int>
    var velocity: SIMD3<Int>

    mutating func addVelocity(_ v: SIMD3<Int>) {
        velocity &+= v
    }

    func pot() -> Int {
        abs(position.x) + abs(position.y) + abs(position.z)
    }

    func kin() -> Int {
        abs(velocity.x) + abs(velocity.y) + abs(velocity.z)
    }

    func posVelX() -> SIMD2<Int> {
        SIMD2(position.x, velocity.x)
    }

    func posVelY() -> SIMD2<Int> {
        SIMD2(position.y, velocity.y)
    }

    func posVelZ() -> SIMD2<Int> {
        SIMD2(position.z, velocity.z)
    }
}

func parse(_ input: [String]) -> [Moon] {
    // The position of each moon is given in your scan; the x, y, and z velocity of each moon starts at 0.
    // input rows have form: <x=-5, y=6, z=-11>
    return input.compactMap { (s) -> Moon? in
        guard !s.isEmpty else { return nil }
        guard let startIndex = s.firstIndex(of: "<"),
            let endIndex = s.firstIndex(of: ">"),
            startIndex < endIndex
            else {
                print("Error, invalid moon input found")
                return nil
        }
        let xyz = s[s.index(startIndex, offsetBy: 1)..<endIndex]
            .split(separator: ",")
            .flatMap { $0.split(separator: "=").compactMap { Int($0) } }
        return Moon(position: SIMD3(xyz[0], xyz[1], xyz[2]),
                    velocity: SIMD3(0, 0, 0))
    }
}

func step(moons: [Moon]) -> [Moon] {
    var updated: [Moon] = moons
    for i in 0..<updated.count-1 {
        for j in i+1..<updated.count {
            var m0 = updated[i]
            var m1 = updated[j]
            var change = SIMD3(0, 0, 0)
            if m0.position.x < m1.position.x {
                change.x = 1
            } else if m0.position.x > m1.position.x {
                change.x = -1
            }
            if m0.position.y < m1.position.y {
                change.y = 1
            } else if m0.position.y > m1.position.y {
                change.y = -1
            }
            if m0.position.z < m1.position.z {
                change.z = 1
            } else if m0.position.z > m1.position.z {
                change.z = -1
            }
            m0.addVelocity(change)
            m1.addVelocity(change &* SIMD3(-1, -1, -1))
            updated[i] = m0
            updated[j] = m1
        }
    }

    return updated.map { Moon(position: $0.position &+ $0.velocity, velocity: $0.velocity) }
}

// PART 1

let testData = "<x=-1, y=0, z=2>\n<x=2, y=-10, z=-7>\n<x=4, y=-8, z=8>\n<x=3, y=5, z=-1>\n".components(separatedBy: "\n")
//var moons = parse(testData)
let originalInput = parse(fileInput.components(separatedBy: "\n"))
var moons = originalInput

for _ in 1...1000 {
    moons = step(moons: moons)
    print(moons)
}

let totalEnergy = moons.reduce(0, { (result, moon) -> Int in
    result + moon.pot() * moon.kin()
})

print("total energy: \(String(describing: totalEnergy))")


// PART 2


// hint: the x, y and z axes are independent and repeat

// can I find the period that each of the axes repeats? If so, should be able to find the
// least common multiple of each rather than brute forcing 

var x=0, y=0, z=0

moons = originalInput
var hashes = Set([moons.map { $0.posVelX() }.hashValue])
var step = 0
while true {
    step += 1
    moons = step(moons: moons)
    if hashes.contains(moons.map { $0.posVelX() }.hashValue) {
        x = step
        break
    } else {
        hashes.insert(moons.map { $0.posVelX() }.hashValue)
    }
}

moons = originalInput
hashes = Set([moons.map { $0.posVelY() }.hashValue])
step = 0
while true {
    step += 1
    moons = step(moons: moons)
    if hashes.contains(moons.map { $0.posVelY() }.hashValue) {
        y = step
        break
    } else {
        hashes.insert(moons.map { $0.posVelY() }.hashValue)
    }
}

moons = originalInput
hashes = Set([moons.map { $0.posVelZ() }.hashValue])
step = 0
while true {
    step += 1
    moons = step(moons: moons)
    if hashes.contains(moons.map { $0.posVelZ() }.hashValue) {
        z = step
        break
    } else {
        hashes.insert(moons.map { $0.posVelZ() }.hashValue)
    }
}

func gcd(_ a: Int, _ b: Int) -> Int {
    // Euclidean algorithm
    if b == 0 {
        return a
    }
    return gcd(b, a % b)
}

func lcm(_ a: Int, _ b: Int) -> Int {
    a * b / gcd(a, b)
}

print("took \(x) \(y) \(z) steps to reach the first state that exactly matches a previous state.")

print("lcm is \(lcm(lcm(x, y), z))")
