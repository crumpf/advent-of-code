import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var reports: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    reports.filter(isSafe(report:)).count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    reports.filter(isDampenerSafe(report:)).count
  }

  // a report only counts as safe if both of the following are true:
  // - The levels are either all increasing or all decreasing.
  // - Any two adjacent levels differ by at least one and at most three.
  private func isSafe(report: [Int]) -> Bool {
    let isIncreasing = report[1] > report[0]
    return zip(report, report.dropFirst()).allSatisfy { pair in
      if (isIncreasing && pair.1 <= pair.0) || (!isIncreasing && pair.1 >= pair.0) {
        return false
      }
      return (1...3).contains(abs(pair.1 - pair.0))
    }
  }

  // Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe
  private func isDampenerSafe(report: [Int]) -> Bool {
    for index in report.indices {
      var r = report
      r.remove(at: index)
      if isSafe(report: r) {
        return true
      }
    }
    return false
  }
}
