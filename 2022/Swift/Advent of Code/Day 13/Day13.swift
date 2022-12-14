//
//  Day13.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/13/22.
//

import Foundation

class Day13: Day {
    func part1() -> String {
        return "\(sumOfIndicesOfPacketsInRightOrder())"
    }
    
    func part2() -> String {
        "\(decoderKeyForOrganizedPacketsWithDividerPackets(["[[2]]", "[[6]]"]))"
    }
    
    enum PacketElement {
        case list([PacketElement])
        case integer(Int)
        
        enum PacketComparison {
            case rightOrder, unknown, wrongOrder
        }
        
        func compareTo(_ other: PacketElement) -> PacketComparison {
            switch (self, other) {
            case let (.integer(myInt), .integer(otherInt)):
                if myInt < otherInt {
                    return .rightOrder
                } else if myInt > otherInt {
                    return .wrongOrder
                } else {
                    return .unknown
                }
            case let (.list(myList), .list(otherList)):
                for values in zip(myList, otherList) {
                    let result = values.0.compareTo(values.1)
                    if result != .unknown {
                        return result
                    }
                }
                if myList.count < otherList.count {
                    return .rightOrder
                } else if myList.count > otherList.count {
                    return .wrongOrder
                } else {
                    return .unknown
                }
            case (.integer, .list):
                return PacketElement.list([self]).compareTo(other)
            case (.list, .integer):
                return self.compareTo(.list([other]))
            }
        }
        
    }
    
    private func packet(from string: String) -> PacketElement {
        // we're assuming here that the input is well-structured
        var stack: [[PacketElement]] = [[]]
        var value: Int?
        for c in string {
            switch c {
            case "[":
                stack.append([PacketElement]())
            case "]":
                if let v = value {
                    stack[stack.indices.endIndex-1].append(PacketElement.integer(v))
                    value = nil
                }
                let a = stack.popLast()!
                stack[stack.indices.endIndex-1].append(PacketElement.list(a))
            case let i where i.isNumber:
                value = 10 * (value ?? 0) + Int(String(c))!
            case ",":
                if let v = value {
                    stack[stack.indices.endIndex-1].append(PacketElement.integer(v))
                    value = nil
                }
            default:
                break
            }
        }
        return PacketElement.list(stack[0])
    }
    
    private func sumOfIndicesOfPacketsInRightOrder() -> Int {
        input.components(separatedBy: "\n\n").map {
            let lines = $0.lines()
            return (packet(from: lines[0]), packet(from: lines[1]))
        }
        .enumerated()
        .reduce(into: 0) { partialResult, enumeration in
            let pair = enumeration.element
            if pair.0.compareTo(pair.1) == .rightOrder {
                partialResult += enumeration.offset + 1 /* 1 based indices */
            }
        }
    }
    
    private func decoderKeyForOrganizedPacketsWithDividerPackets(_ dividerPackets: [String]) -> Int {
        (input.lines() + dividerPackets)
            .filter { !$0.isEmpty }
            .map() {
                (string: $0, packet: packet(from: $0))
            }
            .sorted {
                $0.packet.compareTo($1.packet) == .rightOrder
            }
            .enumerated()
            .filter {
                dividerPackets.firstIndex(of: $0.element.string) != nil
            }
            .reduce(1) { $0 * ($1.offset + 1) /* 1 based indices */ }
    }
    
}
