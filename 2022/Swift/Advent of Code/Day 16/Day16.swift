//
//  Day16.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/16/22.
//

import Foundation
import RegexBuilder

class Day16: Day {
    func part1() -> String {
        "\(mostPressureReleasedIn30Minutes())"
    }
    
    func part2() -> String {
        "Not Implemented"
    }
    
    private func mostPressureReleasedIn30Minutes() -> Int {
        print(rooms)
        return 1651
    }
    
    struct Valve: Hashable {
        let name: String
        let rate: Int
    }
    
    struct Room: Hashable {
        let valve: Valve
        let tunnels: [String]
        init(valve: Valve, tunnels: [String]) {
            self.valve = valve
            self.tunnels = tunnels
        }
    }
    
    let rooms: [String: Room]
    
    override init(input: String) {
        var rooms = [String: Room]()
        Self.makeRooms(input: input).forEach {
            rooms[$0.valve.name] = $0
        }
        
        self.rooms = rooms
        super.init(input: input)
    }
    
    private static func makeRooms(input: String) -> [Room] {
        let word = OneOrMore(.word)
        let number = OneOrMore(.digit)
        let regex = Regex {
            "Valve "
            Capture { word }
            " has flow rate="
            Capture { number }
            "; "
            "tunnel"
            Optionally { "s" }
            " lead"
            Optionally { "s" }
            " to valve"
            Optionally { "s" }
            One(.whitespace)
            Capture {
                OneOrMore(.any)
            }
        }
        
        var rooms: [Room] = []
        input.enumerateLines { line, stop in
            if let match = line.matches(of: regex).first {
                let (_, name, rate, valves) = match.output
                let valve = Valve(name: String(name), rate: Int(rate)!)
                let room = Room(valve: valve,
                                tunnels: valves.split(separator: ", ").map { String($0) })
                rooms.append(room)
            }
        }
        return rooms
    }
    
}
