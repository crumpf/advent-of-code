import Algorithms

struct Day21: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func part1() -> Any {
    let sequences = data.split(separator: "\n")

    return sequences.map {
      let numericPadMoves = Keypads.directionPressesToControlNumberPad(forSequence: String($0))
      print("\($0): \(numericPadMoves)")

      var dirPadMoves = numericPadMoves
      for i in 1...2 {
        dirPadMoves = Keypads.directionPressesToControlDirectionPad(forSequence: dirPadMoves)
        print("\(i): \(dirPadMoves)")
      }

      print("complexity: \(dirPadMoves.count) * \(Int($0.dropLast())!)\n")
      return dirPadMoves.count * Int($0.dropLast())!
    }
    .reduce(0, +)
  }

  func part2() -> Any {
    0
  }

  struct Keypads {
    /*
     +---+---+---+
     | 7 | 8 | 9 |
     +---+---+---+
     | 4 | 5 | 6 |
     +---+---+---+
     | 1 | 2 | 3 |
     +---+---+---+
         | 0 | A |
         +---+---+
     */
    /*
         +---+---+
         | ^ | A |
     +---+---+---+
     | < | v | > |
     +---+---+---+
     */

    static let numericMap: [Character: Int] = ["0":1, "A":2, "1":3, "2":4, "3":5, "4":6, "5":7, "6":8, "7":9, "8":10, "9":11]
    static let directionalMap: [Character: Int] = ["<":0, "v":1, ">":2, "^":4, "A":5]

    static func horizontalMoves(from: Int, to: Int) -> String {
      var moves = ""
      let colDelta = to % 3 - from % 3
      if colDelta > 0 { for _ in 1...colDelta { moves.append(">") } }
      else if colDelta < 0 { for _ in 1...(-colDelta) { moves.append("<") } }
      return moves
    }

    static func verticalMoves(from: Int, to: Int) -> String {
      var moves = ""
      let rowDelta = to / 3 - from / 3
      if rowDelta > 0 { for _ in 1...rowDelta { moves.append("^") } }
      else if rowDelta < 0 { for _ in 1...(-rowDelta) { moves.append("v") } }
      return moves
    }

    static func directionPressesToControlNumberPad(from: Character, to: Character) -> String? {
      guard let fromInt = numericMap[from], let toInt = numericMap[to] else { return nil }
      var moves = ""
      // because of the directional pad configuration, it ends up shortest if we
      // move left first if possible
      if (from == "A" && toInt % 3 != 0) || (from != "A" && fromInt % 3 == 2) {
        moves.append(horizontalMoves(from: fromInt, to: toInt))
        moves.append(verticalMoves(from: fromInt, to: toInt))
      } else {
        moves.append(verticalMoves(from: fromInt, to: toInt))
        moves.append(horizontalMoves(from: fromInt, to: toInt))
      }
      return moves
    }

    static func directionPressesToControlDirectionPad(from: Character, to: Character) -> String? {
      guard let fromInt = directionalMap[from], let toInt = directionalMap[to] else { return nil }
      var moves = ""
      if toInt > fromInt {
        moves.append(horizontalMoves(from: fromInt, to: toInt))
        moves.append(verticalMoves(from: fromInt, to: toInt))
      } else if toInt < fromInt {
        moves.append(verticalMoves(from: fromInt, to: toInt))
        moves.append(horizontalMoves(from: fromInt, to: toInt))
      }
      return moves
    }

    static func directionPressesToControlNumberPad(forSequence seq: String, startingAt: Character = "A") -> String {
      var npMoves = ""
      zip(String(startingAt) + seq, seq).forEach { pair in
        if let moves = Keypads.directionPressesToControlNumberPad(from: pair.0, to: pair.1) {
          npMoves.append(moves)
          npMoves.append("A")
        }
      }
      return npMoves
    }

    static func directionPressesToControlDirectionPad(forSequence seq: String, startingAt: Character = "A") -> String {
      var dpMoves = ""
      zip(String(startingAt) + seq, seq).forEach { pair in
        if let moves = Keypads.directionPressesToControlDirectionPad(from: pair.0, to: pair.1) {
          dpMoves.append(moves)
          dpMoves.append("A")
        }
      }
      return dpMoves
    }
  }
}
