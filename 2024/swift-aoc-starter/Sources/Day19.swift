import Algorithms

struct Day19: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func part1() -> Any {
    let onsen = Onsen(data: data)
    let regex = try! Regex("^(\(onsen.patterns.joined(separator: "|")))+$")
    return onsen.designs.filter { $0.matches(of: regex).count != 0 }.count
  }

  func part2() -> Any {
    let onsen = Onsen(data: data)
    let regex = try! Regex("^(\(onsen.patterns.joined(separator: "|")))+$")
    var cache = [String: Int]()
    return onsen.designs.filter { $0.matches(of:regex).count != 0 }
      .map { numberOfArrangements(design: $0, patterns: onsen.patterns, cache: &cache) }
      .reduce(0, +)
  }

  func numberOfArrangements(design: String, patterns: [String], cache: inout [String: Int]) -> Int {
    if let cached = cache[design] { return cached }

    let count = patterns.filter { design.starts(with: $0) }
      .map {
        let remaining = String(design.dropFirst($0.count))
        return remaining.isEmpty ? 1 : numberOfArrangements(design: remaining, patterns: patterns, cache: &cache)
      }
      .reduce(0, +)
    cache[design] = count
    return count
  }

  struct Onsen {
    let patterns: [String]
    let designs: [String]

    init(data: String) {
      let splits = data.split(separator: "\n\n")
      patterns = splits[0].split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
      designs = splits[1].split(separator: "\n").map(String.init)
    }
  }
}
