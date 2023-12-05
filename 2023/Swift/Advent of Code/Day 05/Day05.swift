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

    struct Almanac {
        let seeds: [Int]
        let maps: [AlmanacMap]

        func soilNumbersForSeeds() -> [Int] {
            seeds.map(soilNumber(forSeed:))
        }

        func soilNumber(forSeed seed: Int) -> Int {
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
        makeAlmanac(input: input).soilNumbersForSeeds().min() ?? Int.max
    }

    private func lowestLocationNumberThatCorrespondsToAnyInitialSeedNumberRanges() -> Int {
        let almanac = makeAlmanac(input: input)
        let ranges = stride(from: 0, to: almanac.seeds.count, by: 2).map { i in
            (almanac.seeds[i]..<(almanac.seeds[i]+almanac.seeds[i+1]))
        }
        // maybe there's an optimization for this, but brute-forcing through
        // all the ranges with -Ofast compiler optimizations gets the job done in
        // about 2.5 mins on an M1 Pro
        let lowest = ranges.map { range in
            range.reduce(range.startIndex) {
                min($0, almanac.soilNumber(forSeed: $1))
            }
        }.min()

        return lowest ?? Int.max
    }

}
