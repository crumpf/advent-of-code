//
//  Day15.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/15/23.
//
//  --- Day 15: Lens Library ---

import Foundation

class Day15: Day {
    func part1() -> String {
        let seqs = makeSequences()
        let sum = seqs.map(HASH(_:)).reduce(0, +)
        return "\(sum)"
    }
    
    func part2() -> String {
        let seqs = makeSequences()
        let boxes = HASHMAP(sequencess: seqs)
        let power = boxes.enumerated().map { box in
            box.element.enumerated().map { lens in
                (box.offset + 1) * (lens.offset + 1) * lens.element.focalLength
            }
            .reduce(0, +)
        }.reduce(0, +)
        return "\(power)"
    }

    struct Lens {
        let label: String
        let focalLength: Int
    }

    private func makeSequences() -> [String] {
        input.trimmingCharacters(in: .newlines).split(separator: ",").map { String($0) }
    }

    func HASH(_ s: any StringProtocol) -> Int {
        var currentValue = 0
        for c in s {
            if c.isNewline { continue }
            guard let ascii = c.asciiValue else {
                abort() // unexpected non-ascii found
            }
            currentValue += Int(ascii)
            currentValue *= 17
            currentValue = currentValue % 256
        }
        return currentValue
    }

    func HASHMAP(sequencess: [String]) -> [[Lens]] {
        var boxes = Array(repeating: [Lens](), count: 256)
        for s in sequencess {
            guard let opIndex = s.firstIndex(where: { $0 == "-" || $0 == "=" }) else {
                abort() // supposed to have an operation character
            }
            let label = s[s.startIndex..<opIndex]
            let boxId = HASH(label)
            switch s[opIndex] {
            case "-":
                boxes[boxId].removeAll(where: {$0.label == label})
            case "=":
                let focalLength = Int(s[s.index(after: opIndex)..<s.endIndex])!
                let lens = Lens(label: String(label), focalLength: focalLength)
                if let idx = boxes[boxId].firstIndex(where: {$0.label == lens.label}) {
                    boxes[boxId][idx] = lens
                } else {
                    boxes[boxId].append(lens)
                }
            default: break
            }
        }
        return boxes
    }
}
