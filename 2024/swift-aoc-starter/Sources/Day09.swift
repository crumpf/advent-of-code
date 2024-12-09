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
    let lengths = diskMap
    var written = Array(repeating: 0, count: lengths.count)
    var fileIDs: [Int?] = diskMap.enumerated().map { $0.offset % 2 == 0 ? $0.offset / 2 : nil }
    var position = 0, checksum = 0
    var index = 0
    while index < fileIDs.count {
      var spaceRemaining = lengths[index] - written[index]
      if let fileID = fileIDs[index] {
        for _ in (0..<spaceRemaining) {
          checksum += position * fileID
          position += 1
        }
        written[index] += spaceRemaining
      } else {
        // try to move something into this free space
        var searchIndex = fileIDs.endIndex - 1
        while spaceRemaining > 0, searchIndex > index {
          if let fileID = fileIDs[searchIndex] {
            let spaceRequired = lengths[searchIndex]
            if spaceRequired <= spaceRemaining {
              for _ in (0..<spaceRequired) {
                checksum += position * fileID
                position += 1
              }
              written[index] += spaceRequired
              spaceRemaining -= spaceRequired
              fileIDs[searchIndex] = nil
            }
          }
          searchIndex -= 1
        }
        if spaceRemaining > 0 {
          position += spaceRemaining
        }
      }
      index += 1
    }
    return checksum
  }
}
