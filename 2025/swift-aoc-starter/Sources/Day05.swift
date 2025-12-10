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
    optimizeRanges(database.freshRanges).reduce(0) { $0 + $1.count }
  }
  
  func optimizeRanges(_ ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
    var optimized = [ClosedRange<Int>]()
    let sorted = ranges.sorted { r1, r2 in
      r1.lowerBound < r2.lowerBound
    }

    var working = sorted[0]
    for r in sorted.dropFirst() {
      if working.overlaps(r) {
        working = working.lowerBound...max(working.upperBound, r.upperBound)
      } else {
        optimized.append(working)
        working = r
      }
    }
    optimized.append(working)

    return optimized
  }
}
