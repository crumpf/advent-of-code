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
        "Not Implemented"
    }

    struct Almanac {
        let seeds: [Int]
        let maps: [AlmanacMap]

        func soilNumbersForSeeds() -> [Int] {
            seeds.map { seed in
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

}
