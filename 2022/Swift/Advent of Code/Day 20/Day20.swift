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
        var list = CircularlyLinkedList<Coordinate>()
        list.insert(encryptedList, at: 0)
        
        for coord in encryptedList {
            let index = list.firstIndex(of: coord)!
            list.remove(at: index)
            let newIndex = {
                switch index + coord.value {
                case let offset where offset > 0:
                    return offset % list.count
                case let offset where offset < 0:
                    let reverseIndex = (((list.count - index) + abs(coord.value)) % list.count)
                    if reverseIndex == 0 { return 0 }
                    return list.count - reverseIndex
                default:
                    return 0
                }
            }()
            list.insert(coord, at: newIndex)
        }
        
        var sum = 0
        if let zeroIndex = list.firstIndex(where: { $0.value == 0} ) {
            sum = [1000, 2000, 3000].map { list.element(at: (zeroIndex + $0) % list.count)!.value }.reduce(0, +)
        }

        return sum
    }
    
    let decryptionKey = 811589153
    
    func sumOfDecryptedGroveCoordinates() -> Int {
        
        var list = CircularlyLinkedList<Coordinate>()
        list.insert(decryptedList, at: 0)
        
        for _ in 1...10 {
            for coord in decryptedList {
                let index = list.firstIndex(of: coord)!
                list.remove(at: index)
                let newIndex = {
                    switch index + coord.value {
                    case let offset where offset > 0:
                        return offset % list.count
                    case let offset where offset < 0:
                        let reverseIndex = (((list.count - index) + abs(coord.value)) % list.count)
                        if reverseIndex == 0 { return 0 }
                        return list.count - reverseIndex
                    default:
                        return 0
                    }
                }()
                list.insert(coord, at: newIndex)
            }
        }
        
        var sum = 0
        if let zeroIndex = list.firstIndex(where: { $0.value == 0} ) {
            sum = [1000, 2000, 3000].map { list.element(at: (zeroIndex + $0) % list.count)!.value }.reduce(0, +)
        }

        return sum
    }
    
    private lazy var encryptedList = input.lines().enumerated().map { (n, value) in
        Coordinate(id: n, value: Int(value)!)
    }
    
    private lazy var decryptedList = input.lines().enumerated().map { (n, value) in
        Coordinate(id: n, value: Int(value)! * decryptionKey)
    }
}
