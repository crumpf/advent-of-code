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
    0
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
