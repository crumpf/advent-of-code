import Algorithms

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var diskMap: [Int] {
    data.split(separator: "\n").first!.map { Int(String($0))! }
  }

  var checksum: Int {
    var map = diskMap
    var position = -1, checksum = 0, endIndex = map.endIndex - 1
    endIndex -= endIndex % 2 == 0 ? 0 : 1 // make sure endIndex doesn't start on free space
    for index in map.indices {
      let isFreeSpace = index % 2 != 0
      for _ in (0..<map[index]) {
        position += 1
        if !isFreeSpace {
          let fileID = index / 2
          checksum += position * fileID
        } else {
          guard endIndex > index else {
            return checksum
          }
          while map[endIndex] == 0 {
            endIndex -= 2
            guard endIndex > index else {
              return checksum
            }
          }
          let fileID = endIndex / 2
          checksum += position * fileID
          map[endIndex] -= 1
        }
      }
    }
    return checksum
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    checksum
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    0
  }
}
