import Algorithms

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Database {
    let freshRanges: [ClosedRange<Int>]
    let ingredientIds: Set<Int>
  }

  // Splits input data into its component parts and convert from string.
  var database: Database {
    let dbData = data.split(separator: "\n\n")
    let ranges = dbData[0].split(separator: "\n").map {
      let r = $0.split(separator: "-")
      return Int(r[0])!...Int(r[1])!
    }
    let ids = dbData[1].split(separator: "\n").compactMap  { Int($0) }
    return Database(freshRanges: ranges, ingredientIds: Set(ids))
  }

  func part1() -> Any {
    let db = database
    return db.ingredientIds.filter { id in
      !db.freshRanges.allSatisfy { !$0.contains(id) }
    }
    .count
  }

  func part2() -> Any {
    0
  }
}
