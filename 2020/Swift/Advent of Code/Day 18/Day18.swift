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
    return String(input
                    .replacingOccurrences(of: " ", with: "")
                    .lines()
                    .map { solveWithPrecedence(expression: $0) }
                    .reduce(0, +))
  }
  
  private func solveExpression(_ expression: String) -> Int {
    guard let leftOperandString = firstOperand(in: expression) else { return 0 }
    var leftOperand = Int(leftOperandString) ?? solveExpression(String(leftOperandString.dropFirst().dropLast()))
    var remainingExpression = String(expression.dropFirst(leftOperandString.count))
    while !remainingExpression.isEmpty {
      if let operation = remainingExpression.first {
        remainingExpression = String(remainingExpression.dropFirst())
        guard let rightOperandString = firstOperand(in: remainingExpression) else { abort() /* error */ }
        let rightOperand = Int(rightOperandString) ?? solveExpression(String(rightOperandString.dropFirst().dropLast()))
        remainingExpression = String(remainingExpression.dropFirst(rightOperandString.count))
        switch operation {
        case "+":
          leftOperand += rightOperand
        case "*":
          leftOperand *= rightOperand
        default:
          print("error: found operator \(operation)")
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
  
  private func solveWithPrecedence(expression: String) -> Int {
    guard let leftOperandString = firstOperand(in: expression) else { return 0 }
    var leftOperand = Int(leftOperandString) ?? solveWithPrecedence(expression: String(leftOperandString.dropFirst().dropLast()))
    var remainingExpression = String(expression.dropFirst(leftOperandString.count))
    while !remainingExpression.isEmpty {
      if let operation = remainingExpression.first {
        remainingExpression = String(remainingExpression.dropFirst())
        switch operation {
        case "+":
          guard let rightOperandString = firstOperand(in: remainingExpression) else { abort() /* error */ }
          let rightOperand = Int(rightOperandString) ?? solveWithPrecedence(expression: String(rightOperandString.dropFirst().dropLast()))
          remainingExpression = String(remainingExpression.dropFirst(rightOperandString.count))
          leftOperand += rightOperand
        case "*":
          leftOperand *= solveWithPrecedence(expression: remainingExpression)
          remainingExpression = String(remainingExpression.dropFirst(remainingExpression.count))
        default:
          print("error: found operator \(operation)")
          abort()
        }
      }
    }
    return leftOperand
  }
  
}
