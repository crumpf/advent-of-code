// https://adventofcode.com/2019/day/1

import Foundation

var str = "Advent of Code 2019, Day 1"
print(str)

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

print("PART 1")

let masses = fileInput.components(separatedBy: "\n").compactMap { Int($0) }
print("calculating the fuel requirments for \(masses.count) modules")

func fuelRequired(forMass mass: Int) -> Int {
    // to find the fuel required for a module, take its mass, divide by three, round down, and subtract 2
    return mass / 3 - 2
}

func testFuelRequired(mass: Int, correctFuel: Int) {
    guard fuelRequired(forMass: mass) == correctFuel else {
        print("Testing that mass \(mass) needs \(correctFuel) FAILED")
        return
    }
    print("Testing that mass \(mass) needs \(correctFuel) PASSED")
}

testFuelRequired(mass: 12, correctFuel: 2)
testFuelRequired(mass: 14, correctFuel: 2)
testFuelRequired(mass: 1969, correctFuel: 654)
testFuelRequired(mass: 100756, correctFuel: 33583)

let sum = masses.reduce(0, { $0 + fuelRequired(forMass: $1) })

print("sum of the fuel requirements: \(sum)")

// https://adventofcode.com/2019/day/1#part2
print("\nPART 2")

/*
 Fuel itself requires fuel just like a module - take its mass, divide by three, round down, and subtract 2. However, that fuel also requires fuel, and that fuel requires fuel, and so on. Any mass that would require negative fuel should instead be treated as if it requires zero fuel; the remaining mass, if any, is instead handled by wishing really hard, which has no mass and is outside the scope of this calculation.

 So, for each module mass, calculate its fuel and add it to the total. Then, treat the fuel amount you just calculated as the input mass and repeat the process, continuing until a fuel requirement is zero or negative.
 */

func totalFuelRequired(forMass mass: Int) -> Int {
    let fuel = fuelRequired(forMass: mass)
    if (fuel > 0) {
        return fuel + totalFuelRequired(forMass: fuel)
    }
    return 0
}

func testTotalFuelRequired(mass: Int, correctFuel: Int) {
    guard totalFuelRequired(forMass: mass) == correctFuel else {
        print("Testing that mass \(mass) needs total \(correctFuel) FAILED")
        return
    }
    print("Testing that mass \(mass) needs total \(correctFuel) PASSED")
}

testTotalFuelRequired(mass: 14, correctFuel: 2)
testTotalFuelRequired(mass: 1969, correctFuel: 966)
testTotalFuelRequired(mass: 100756, correctFuel: 50346)

let totalSum = masses.reduce(0, {$0 + totalFuelRequired(forMass: $1)})

print("total sum of the fuel requirements: \(totalSum)")
