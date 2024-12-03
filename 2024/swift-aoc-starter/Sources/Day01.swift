import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // make lists from input data
  func makeLists() -> ([Int], [Int]) {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }.reduce(into: ([Int](), [Int]())) { partialResult, row in
      partialResult.0.append(row[0])
      partialResult.1.append(row[1])
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let lists = makeLists()
    // order the lists and add up distances between the entries
    return zip(lists.0.sorted(), lists.1.sorted()).map { abs($0.0 - $0.1) }.reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let lists = makeLists()
    // calculate similarity score
    return lists.0.reduce(0) { partialResult, num in
      partialResult + num * lists.1.filter({ $0 == num }).count
    }
  }
}
