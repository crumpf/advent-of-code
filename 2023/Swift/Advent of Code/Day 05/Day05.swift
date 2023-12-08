//
//  Day05.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/05/23.
//

import Foundation

class Day05: Day {
    func part1() -> String {
        "\(lowestLocationNumberThatCorrespondsToAnyInitialSeedNumbers())"
    }
    
    func part2() -> String {
        "\(lowestLocationNumberThatCorrespondsToAnyInitialSeedNumberRanges())"
    }

    func part2Optimized() -> String {
        "\(lowestLocationNumberThatCorrespondsToAnyInitialSeedNumberRangesOptimized())"
    }

    struct Almanac {
        let seeds: [Int]
        let maps: [AlmanacMap]

        func locationsForSeeds() -> [Int] {
            seeds.map(location(forSeed:))
        }

        func location(forSeed seed: Int) -> Int {
            maps.reduce(seed) { partialResult, m in
                if let matchedRange = m.ranges.first(where: { range in
                    (range.sourceRangeStart..<(range.sourceRangeStart+range.rangeLength)).contains(partialResult)
                }) {
                    return matchedRange.destinationRangeStart + (partialResult - matchedRange.sourceRangeStart)
                }
                return partialResult
            }
        }
    }

    struct AlmanacMap {
        let name: String
        let ranges: [AlmanacMapRange]
    }

    struct AlmanacMapRange {
        let destinationRangeStart, sourceRangeStart, rangeLength: Int
    }

    private func makeAlmanac(input: String) -> Almanac {
        let sections = input.components(separatedBy: "\n\n")
        let seeds = sections[0].dropFirst("seeds: ".count).components(separatedBy: " ").compactMap(Int.init)
        let maps = sections.dropFirst().map { mapBlock in
            let lines = mapBlock.lines()
            let name = lines.first!
            let ranges = lines.dropFirst().map { line in
                let rangeNums = line.components(separatedBy: " ").compactMap(Int.init)
                return AlmanacMapRange(
                    destinationRangeStart: rangeNums[0],
                    sourceRangeStart: rangeNums[1],
                    rangeLength: rangeNums[2]
                )
            }
            return AlmanacMap(name: name, ranges: ranges)
        }
        return Almanac(seeds: seeds, maps: maps)
    }

    private func lowestLocationNumberThatCorrespondsToAnyInitialSeedNumbers() -> Int {
        makeAlmanac(input: input).locationsForSeeds().min() ?? -1
    }

    private func lowestLocationNumberThatCorrespondsToAnyInitialSeedNumberRanges() -> Int {
        let almanac = makeAlmanac(input: input)
        let ranges = stride(from: 0, to: almanac.seeds.count, by: 2).map { i in
            (almanac.seeds[i]..<(almanac.seeds[i]+almanac.seeds[i+1]))
        }
        // Not optimal, but brute-forcing through all the ranges with Swift Compilier -O and
        // Apple Clang -Ofast compiler optimizations gets the job done in about 2.5 mins on an M1 Pro.
        let lowest = ranges.map { range in
            range.reduce(Int.max) {
                min($0, almanac.location(forSeed: $1))
            }
        }.min()

        return lowest ?? -1
    }

    private func lowestLocationNumberThatCorrespondsToAnyInitialSeedNumberRangesOptimized() -> Int {
        let almanac = makeAlmanac(input: input)
        // Start at location zero and increment, completing when we find the smallest value that reverse-maps to one of our starting seeds.
        // This finishes in about 4 seconds compared to 2.5 minutes in my first approach.
        for loc in (0...) {
            // work backwards to the seed
            let seed = almanac.maps.reversed().reduce(loc) { partialResult, m in
                if let found = m.ranges.first(where: { r in
                    (r.destinationRangeStart..<(r.destinationRangeStart+r.rangeLength)).contains(partialResult)
                }) {
                    return found.sourceRangeStart + (partialResult - found.destinationRangeStart)
                }
                return partialResult
            }
            // check if it's one of our initial seeds
            if nil != stride(from: 0, to: almanac.seeds.count, by: 2).map({ i in
                (almanac.seeds[i]..<(almanac.seeds[i]+almanac.seeds[i+1]))
            }).first(where: { r in
                r.contains(seed)
            }) {
                return loc
            }
        }

        return -1
    }

}
