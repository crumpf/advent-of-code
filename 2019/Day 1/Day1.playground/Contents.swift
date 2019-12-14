import UIKit

// https://adventofcode.com/2019/day/1

var str = "Advent of Code 2019, Day 1"
print(str)

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let input = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
let masses = input.components(separatedBy: "\n").compactMap { Int($0) }

print("PART 1")
print("calculating the fuel requirments for \(masses.count) modules")

func fuelRequired(forMass mass: Int) -> Int {
    // to find the fuel required for a module, take its mass, divide by three, round down, and subtract 2
    return mass / 3 - 2
}

fuelRequired(forMass: 12)
fuelRequired(forMass: 14)
fuelRequired(forMass: 1969)
fuelRequired(forMass: 100756)

let sum = masses.reduce(0, { $0 + fuelRequired(forMass: $1) })

print("sum of the fuel requirements: \(sum)")
// correct answer is 3232358

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

totalFuelRequired(forMass: 14)
totalFuelRequired(forMass: 1969)
totalFuelRequired(forMass: 100756)

let totalSum = masses.reduce(0, {$0 + totalFuelRequired(forMass: $1)})

print("total sum of the fuel requirements: \(totalSum)")
// correct answer is 4845669
