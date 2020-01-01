//
//  main.swift
//  AoC2019 Day 14
//
//  Created by Chris Rumpf on 12/31/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

import Foundation

// --- Day 14: Space Stoichiometry ---

// a list of the reactions it can perform that are relevant to this process (your puzzle input). Every reaction turns some quantities of specific input chemicals into some quantity of an output chemical. Almost every chemical is produced by exactly one reaction; the only exception, ORE, is the raw material input to the entire process and is not produced by a reaction.
let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

// You just need to know how much ORE you'll need to collect before you can produce one unit of FUEL.

struct IO {
    let quantity: Int
    let chemical: String
}

struct Reaction {
    let input: [IO]
    let output: IO

    // a Reaction equation looks like:
    // 5 LKQCJ, 1 GDSDP, 2 HPXCL => 9 LVRSZ
    static func reaction(describedBy equation: String) -> Reaction? {
        let comps = equation.components(separatedBy: " => ")
        guard comps.count == 2 else {
            return nil
        }

        let mapToIO: (String) -> IO = { (ss) -> IO in
            let ioComponents = ss.components(separatedBy: " ")
            return IO(quantity: Int(ioComponents[0])!, chemical: ioComponents[1])
        }
        let input = comps[0].components(separatedBy: ", ").map(mapToIO)
        let output = mapToIO(comps[1])

        return Reaction(input: input, output: output)
    }
}

func oreReactions(reactions: [Reaction]) -> [Reaction] {
    reactions.filter { $0.input.count == 1 && $0.input[0].chemical == "ORE" }
}

var leftovers: [String: Int] = [:]

func reduce(chemical: String, reactions: [Reaction]) -> (Int, [String: Int]) {
    let r = reactions.first(where: { $0.output.chemical == chemical })!
    var oreCount = 0
    for input in r.input {
        let dependentReaction = reactions.first(where: { $0.output.chemical == input.chemical })!
        if dependentReaction.input[0].chemical == "ORE" {
            let have = leftovers[input.chemical] ?? 0
            let need = input.quantity - have
            if need > 0 {
                let multiplier = Int(ceil(Double(need) / Double(dependentReaction.output.quantity)))
                oreCount += dependentReaction.input[0].quantity * multiplier
                let made = dependentReaction.output.quantity * multiplier
                leftovers[input.chemical] = have + made - input.quantity
            } else {
                leftovers[input.chemical] = have - input.quantity
            }
            continue
        } else {
            let have = leftovers[input.chemical] ?? 0
            let need = input.quantity - have
            if need > 0 {
                let multiplier = Int(ceil(Double(need) / Double(dependentReaction.output.quantity)))
                for _ in 1...multiplier {
                    let (c, _) = reduce(chemical: input.chemical, reactions: reactions)
                    oreCount += c
                }
                let made = dependentReaction.output.quantity * multiplier
                leftovers[input.chemical] = have + made - input.quantity
            } else {
                leftovers[input.chemical] = have - input.quantity
            }
        }
    }
    return (oreCount, leftovers)
}

func test1() {
    let testInput = "10 ORE => 10 A\n1 ORE => 1 B\n7 A, 1 B => 1 C\n7 A, 1 C => 1 D\n7 A, 1 D => 1 E\n7 A, 1 E => 1 FUEL\n"
    let testReactions = testInput.components(separatedBy: "\n").compactMap { Reaction.reaction(describedBy: $0) }
    let reducedFuel = reduce(chemical: "FUEL", reactions: testReactions)
    print(reducedFuel)
}
test1()

func test2() {
    let testInput = "157 ORE => 5 NZVS\n165 ORE => 6 DCFZ\n44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL\n12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ\n179 ORE => 7 PSHF\n177 ORE => 5 HKGWZ\n7 DCFZ, 7 PSHF => 2 XJWVT\n165 ORE => 2 GPVTF\n3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT\n"
    let testReactions = testInput.components(separatedBy: "\n").compactMap { Reaction.reaction(describedBy: $0) }
    let reducedFuel = reduce(chemical: "FUEL", reactions: testReactions)
    print(reducedFuel)
}
test2()

func test3() {
    let testInput = "171 ORE => 8 CNZTR\n7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL\n114 ORE => 4 BHXH\n14 VRPVC => 6 BMBT\n6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL\n6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT\n15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW\n13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW\n5 BMBT => 4 WPTQ\n189 ORE => 9 KTJDG\n1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP\n12 VRPVC, 27 CNZTR => 2 XDBXC\n15 KTJDG, 12 BHXH => 5 XCVML\n3 BHXH, 2 VRPVC => 7 MZWV\n121 ORE => 7 VRPVC\n7 XCVML => 6 RJRHP\n5 BHXH, 4 VRPVC => 5 LTCX\n"
    let testReactions = testInput.components(separatedBy: "\n").compactMap { Reaction.reaction(describedBy: $0) }
    let reducedFuel = reduce(chemical: "FUEL", reactions: testReactions)
    print(reducedFuel)
}
test3()

print("\nPART 1:\n")

let reactions = fileInput.components(separatedBy: "\n").compactMap { Reaction.reaction(describedBy: $0) }
// find FUEL
let reducedFuel = reduce(chemical: "FUEL", reactions: reactions)
print("ORE needed to produce 1 FUEL: \(reducedFuel.0)")

