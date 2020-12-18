//
//  Day18.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

class Day18: Day {
  
  /// Evaluate the expression on each line of the homework; what is the sum of the resulting values?
  func part1() -> String {
    return String(input
                    .replacingOccurrences(of: " ", with: "")
                    .lines()
                    .map { solveExpression($0) }
                    .reduce(0, +))
  }
  
  func part2() -> String {
    "Not Implemented"
  }
  
  private func solveExpression(_ expression: String) -> Int {
    guard let leftOperandString = firstOperand(in: expression) else { return 0 }
    var leftOperand = leftOperandString.count == 1 ? Int(leftOperandString)! : solveExpression(String(leftOperandString.dropFirst().dropLast()))
    var reducingExpression = String(expression.dropFirst(leftOperandString.count))
    while !reducingExpression.isEmpty {
      if let op = reducingExpression.first {
        reducingExpression = String(reducingExpression.dropFirst())
        guard let rightOperandString = firstOperand(in: reducingExpression) else { abort() /* error */ }
        let rightOperand = rightOperandString.count == 1 ? Int(rightOperandString)! : solveExpression(String(rightOperandString.dropFirst().dropLast()))
        reducingExpression = String(reducingExpression.dropFirst(rightOperandString.count))
        switch op {
        case "+":
          leftOperand += rightOperand
        case "*":
          leftOperand *= rightOperand
        default:
          print("error: found operator \(op)")
          abort()
        }
      }
    }
    return leftOperand
  }
  
  private func firstOperand(in expression: String) -> String? {
    guard let firstChar = expression.first else { return nil }
    
    if firstChar == "(" {
      var parenCount = 0
      for (i, c) in expression.enumerated() {
        switch c {
        case "(":
          parenCount += 1
        case ")":
          parenCount -= 1
          if parenCount == 0 {
            return String(expression.prefix(i+1))
          }
        default:
          break
        }
      }
    }
    
    return String(firstChar)
  }
  
}

