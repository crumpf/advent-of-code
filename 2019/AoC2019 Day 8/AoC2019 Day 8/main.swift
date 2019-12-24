//
//  main.swift
//  AoC2019 Day 8
//
//  Created by Chris Rumpf on 12/23/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

// https://adventofcode.com/2019/day/8

import Foundation

var str = "Advent of Code 2019, Day 5"
print(str)

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

let input = fileInput.components(separatedBy: "\n")[0]
let imageData = Array(input).compactMap { Int(String($0)) }


func printLayer(_ layer: [[Int]]) {
    for array in layer {
        for value in array {
            print(value, terminator: " ")
        }
        print(" ")
    }
}

class ElfBitmap {
    let width: Int
    let height: Int
    var layers: [[[Int]]]

    init?(width: Int, height: Int, input: [Int]) {
        guard input.count % (width * height) == 0 else {
            return nil
        }

        self.width = width
        self.height = height
        self.layers = [[[Int]]]()

        var i = 0
        var layer = Array(repeating: Array(repeating: 0, count: width), count: height)
        while i < input.count {
            layer[i/width % height][i % width] = input[i]
            i += 1
            if i % (width * height) == 0 {
                layers.append(layer)
                layer = Array(repeating: Array(repeating: 0, count: width), count: height)
            }
        }
    }

    func decode() -> [[Int]] {
        layers.reduce(into: Array(repeating: Array(repeating: 2, count: width), count: height)) { (result, layer) in
            for row in 0..<height {
                for col in 0..<width {
                    if result[row][col] == 2 {
                        result[row][col] = layer[row][col]
                    }
                }
            }
        }
    }
}

if let part1 = ElfBitmap(width: 25, height: 6, input: imageData) {
    // find layer with fewest 0 digits
    var zeroCount: Int
    var minZerosFound = Int.max
    var minZerosLayer = -1
    var layerIndex = 0
    for lyr in part1.layers {
        zeroCount = 0
        for row in lyr {
            for val in row {
                if val == 0 {
                    zeroCount += 1
                }
            }
        }
        if zeroCount < minZerosFound {
            minZerosFound = zeroCount
            minZerosLayer = layerIndex
        }
        layerIndex += 1
    }

    print("min zeros: layer \(minZerosLayer), numZeroes \(minZerosFound)")

    let minLayer = part1.layers[minZerosLayer]
    var onesCount = 0
    var twosCount = 0
    for row in minLayer {
        for val in row {
            if val == 1 {
                onesCount += 1
            } else if val == 2 {
                twosCount += 1
            }
        }
    }

    print("the number of 1 digits multiplied by the number of 2 digits = \(onesCount * twosCount)")
}

if let part2 = ElfBitmap(width: 25, height: 6, input: imageData) {
    let decodedImage = part2.decode()
    printLayer(decodedImage)
}
