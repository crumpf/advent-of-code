import Algorithms

struct Day22: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func part1() -> Any {
    data.split(separator: "\n").map {
      var secret = Int($0)!
      for _ in (1...2000) {
        secret = evolve(secret: secret)
      }
      return secret
    }
    .reduce(0, +)
  }

  func part2() -> Any {
    0
  }

  func evolve(secret: Int) -> Int {
    var evolvedSecret = prune(mix(secret * 64, into: secret))
    evolvedSecret = prune(mix(evolvedSecret / 32, into: evolvedSecret))
    return prune(mix(evolvedSecret * 2048, into: evolvedSecret))
  }

  func mix(_ value: Int, into secret: Int) -> Int {
    value ^ secret
  }

  func prune(_ secret: Int) -> Int {
    secret % 16777216
  }

 }
