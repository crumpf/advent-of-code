import Algorithms

struct Day15: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func warehouse() -> Warehouse {
    let splits = data.split(separator: "\n\n"), rows = splits[0].split(separator: "\n")
    let height = rows.count, width = rows[0].count
    var walls = Set<SIMD2<Int>>(), boxes = Set<SIMD2<Int>>(), robot: SIMD2<Int> = SIMD2(-1, -1)
    for (y, row) in rows.enumerated() {
      for (x, c) in row.enumerated() {
        switch c {
        case "#": walls.insert(SIMD2(x, y))
        case "O": boxes.insert(SIMD2(x, y))
        case "@": robot = SIMD2(x, y)
        default: break
        }
      }
    }
    let instructions = Array(splits[1].replacing("\n", with: ""))
    return Warehouse(width: width, height: height, walls: walls, boxes: boxes, robot: robot, instructions: instructions)
  }
  
  func part1() -> Any {
    warehouse().boxesAfterRobotMoves().reduce(0) { $0 + 100 * $1.y + $1.x }
  }

  func part2() -> Any {
    0
  }

  struct Warehouse {
    let width: Int
    let height: Int
    let walls: Set<SIMD2<Int>>
    let boxes: Set<SIMD2<Int>>
    let robot: SIMD2<Int>
    let instructions: [Character]
    
    func boxesAfterRobotMoves() -> Set<SIMD2<Int>> {
      var movedBoxes = boxes
      var robotPosition = robot
      for instruction in instructions {
        robotPosition = move(instruction, from: robotPosition, movingBoxes: &movedBoxes)
      }
      return movedBoxes
    }
    
    func move(_ direction: Character, from position: SIMD2<Int>, movingBoxes: inout Set<SIMD2<Int>>) -> SIMD2<Int> {
      let to: SIMD2<Int>
      switch direction {
      case ">": to = position &+ SIMD2(1,0)
      case "v": to = position &+ SIMD2(0,1)
      case "<": to = position &+ SIMD2(-1,0)
      case "^": to = position &+ SIMD2(0,-1)
      default: return position
      }
      
      guard !walls.contains(to) else { return position }
      
      if movingBoxes.contains(to) {
        let updatedBox = move(direction, from: to, movingBoxes: &movingBoxes)
        if to != updatedBox {
          movingBoxes.remove(to)
          movingBoxes.insert(updatedBox)
          return to
        } else {
          return position
        }
      }
      
      return to
    }
  }
}
