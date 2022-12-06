//
//  Day06.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/06/20.
//

import Foundation

class Day06: Day {
    
    func part1() -> String {
        guard let num = processUntilFirstStartMessageMarker(dataStream: input, markerLength: 4) else {
            return "Not Found"
        }
        return "\(num)"
    }
    
    func part2() -> String {
        guard let num = processUntilFirstStartMessageMarker(dataStream: input, markerLength: 14) else {
            return "Not Found"
        }
        return "\(num)"
    }
    
    private func processUntilFirstStartMessageMarker(dataStream: String, markerLength: Int) -> Int? {
        guard dataStream.count >= markerLength else { return nil }
        for end in stride(from: markerLength, to: input.count, by: 1) {
            if Set(input[(end-markerLength)..<end]).count == markerLength {
                return end
            }
        }
        return nil
    }
    
}
