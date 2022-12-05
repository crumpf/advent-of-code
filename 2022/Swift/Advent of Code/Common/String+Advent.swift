//
//  String+Advent.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/4/20.
//

import Foundation

extension String {
  func lines() -> [String] {
    trimmingCharacters(in: .newlines).components(separatedBy: .newlines)
  }
}
