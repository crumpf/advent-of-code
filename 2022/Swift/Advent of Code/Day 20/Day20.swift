//
//  Day20.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on MM/DD/YY.
//

import Foundation

class Day20: Day {
    func part1() -> String {
        "\(sumOfNumbersFormingTheGroveCoordinates())"
    }
    
    func part2() -> String {
        "\(sumOfDecryptedGroveCoordinates())"
    }
    
    struct Coordinate: Hashable {
        let id: Int
        let value: Int
    }

    private func sumOfNumbersFormingTheGroveCoordinates() -> Int {
        let list = mix(encryptedList)
        return calculateGroveCoordinates(from: list)
    }
    
    let decryptionKey = 811589153
    
    private func sumOfDecryptedGroveCoordinates() -> Int {
        let list = mix(decryptedList, numberOfTimes: 10)
        return calculateGroveCoordinates(from: list)
    }
    
    private func mix(_ coordinates: [Coordinate], numberOfTimes: Int = 1) -> [Coordinate] {
        var list = coordinates
        for _ in 1...numberOfTimes {
            for coord in coordinates {
                let index = list.firstIndex(of: coord)!
                list.remove(at: index)
                let newIndex: Int
                let offset = index + coord.value
                if offset >= 0 {
                    newIndex = offset % list.count
                } else {
                    let reverseIndex = (((list.count - index) + abs(coord.value)) % list.count)
                    newIndex = reverseIndex == 0 ? 0 : list.count - reverseIndex
                }
                list.insert(coord, at: newIndex)
            }
        }
        return list
    }
    
    private func calculateGroveCoordinates(from list: [Coordinate]) -> Int {
        if let zeroIndex = list.firstIndex(where: { $0.value == 0} ) {
            return [1000, 2000, 3000].map { list[(zeroIndex + $0) % list.count].value }.reduce(0, +)
        }
        return 0
    }
    
    private lazy var encryptedList = input.lines().enumerated().map { (n, value) in
        Coordinate(id: n, value: Int(value)!)
    }
    
    private lazy var decryptedList = input.lines().enumerated().map { (n, value) in
        Coordinate(id: n, value: Int(value)! * decryptionKey)
    }
}
