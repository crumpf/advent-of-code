//
//  Day20.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day20: Day {
  func part1() -> String {
    var e = enhancer
    for _ in 1...2 {
      e = ImageEnhancer(algorithm: e.algorithm, inputImage: e.enhance(), infinityPixel: e.enhancedInfinitePixel())
    }
    printMap(e.inputImage)
    
    let result = e.inputImage.map { $0.reduce(0) { $0 + ($1 == .light ? 1 : 0) } }
      .reduce(0, +)
    return "\(result)"
    
    // bad answer 5438
  }
  
  func part2() -> String {
    return ""
  }
  
  let enhancer: ImageEnhancer
  
  override init(input: String) {
    let parts = input.components(separatedBy: "\n\n")
    enhancer = ImageEnhancer(algorithmString: parts[0], inputImageLines: parts[1].lines(), infinityPixel: .dark)
    
    super.init(input: input)
  }
  
  struct ImageEnhancer {
    let algorithm: [Pixel]
    let inputImage: [[Pixel]]
    let infinityPixel: Pixel // images are "infinite" and surrounded by this pixel outside the inputImage
    
    init(algorithmString: String, inputImageLines: [String], infinityPixel: Pixel) {
      self.init(algorithm: algorithmString.compactMap { Pixel(rawValue: $0) },
                inputImage: inputImageLines.map { $0.compactMap { Pixel(rawValue: $0) } },
                infinityPixel: infinityPixel
      )
    }
    
    init(algorithm: [Pixel], inputImage: [[Pixel]], infinityPixel: Pixel) {
      self.algorithm = algorithm
      self.inputImage = inputImage
      self.infinityPixel = infinityPixel
    }
    
    // given inputImage of size N x M, returns an enhanced image of size (N+2) x (M+2)
    func enhance() -> [[Pixel]] {
      let inputRowCount = inputImage.count
      let inputColSize = inputImage[0].count
      var enhanced: [[Pixel]] = []
      for row in -1...inputRowCount  {
        var enhancedRow: [Pixel] = []
        for col in -1...inputColSize {
          enhancedRow.append(enhancedPixel(atLocation: GridLocation(row: row, col: col)))
        }
        enhanced.append(enhancedRow)
      }
      return enhanced
    }
    
    func enhancedPixel(atLocation loc: GridLocation) -> Pixel {
      var binaryString = ""
      for row in (loc.row-1)...(loc.row+1) {
        for col in (loc.col-1)...(loc.col+1) {
          if inputImage.indices.contains(row) && inputImage[0].indices.contains(col) {
            binaryString.append(inputImage[row][col] == .light ? "1" : "0")
          } else {
            binaryString.append(infinityPixel == .light ? "1" : "0")
          }
        }
      }
      guard binaryString.count == 9,
            let algoIndex = Int(binaryString, radix: 2),
            algorithm.indices.contains(algoIndex)
      else {
        assertionFailure()
        return .dark
      }
      return algorithm[algoIndex]
    }
    
    func enhancedInfinitePixel() -> Pixel {
      // after an enhancement, the pixels described by regions completely ouside of
      // the input image have to be mapped as well according to the algorithm.
      // so just map a single pixel known to be ouside the input image
      return enhancedPixel(atLocation: GridLocation(row: -10, col: -10))
    }
  }
  
  enum Pixel: Character {
    case light = "#"
    case dark = "."
  }
  
  func printMap(_ map: [[Pixel]]) {
    for row in map {
      print(row.reduce("") { $0 + String($1.rawValue) })
    }
  }
  
}
