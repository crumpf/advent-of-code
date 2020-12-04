import Foundation

struct Cartesian { var x, y: Int }
struct Slope { let right, down: Int }

class Day3 {
  
  private func parseInput(_ input: [String]) -> [[Character]] {
    input.map { Array($0) }
  }
  
  private func treesInPath(map: [[Character]], start: Cartesian, slope: Slope) -> Int {
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
  
}

extension Day3: Puzzle {
  func part1(withInput: [String]) -> String {
    let map = parseInput(withInput)
    let start = Cartesian(x: 0, y: 0)
    let slope = Slope(right: 3, down: 1)
    let treeCount = treesInPath(map: map, start: start, slope: slope)
    
    return String(describing: treeCount)
  }
  
  func part2(withInput: [String]) -> String {
    let map = parseInput(withInput)
    let start = Cartesian(x: 0, y: 0)
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
    
    let result = hit.reduce(1) { $0 * $1 }
    return String(describing: result)
  }
}

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day3()

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.lines)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.lines)
print(part2)
