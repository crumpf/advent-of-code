// https://adventofcode.com/2020/day/3

import Foundation

//--- Day 3: Toboggan Trajectory ---

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let rawInput = try String(contentsOf: fileURL, encoding: .utf8)

let map = rawInput.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).map { Array($0) }

struct Cartesian { var x, y: Int }
struct Slope { let right, down: Int }

func treesInPath(map: [[Character]], start: Cartesian, slope: Slope) -> Int {
  var location = start
  var treesHit = 0
  
  for y in stride(from: location.y, to: map.endIndex, by: slope.down) {
    let row = map[y]
    if row[location.x % row.count] == "#" {
      treesHit += 1
    }
    
    location.x += slope.right
    location.y = y
  }
  
  return treesHit
}

let start = Cartesian(x: 0, y: 0)
let slope = Slope(right: 3, down: 1)

print(treesInPath(map: map, start: start, slope: slope))

let slopes = [
  Slope(right: 1, down: 1),
  Slope(right: 3, down: 1),
  Slope(right: 5, down: 1),
  Slope(right: 7, down: 1),
  Slope(right: 1, down: 2) ]

var hit: [Int] = []
for slope in slopes {
  hit.append(treesInPath(map: map, start: start, slope: slope))
}

print(hit.reduce(1) { $0 * $1 })
