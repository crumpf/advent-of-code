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
    let warehouse = warehouse()
    let wideWalls = Set(warehouse.walls.map { [SIMD2(2 * $0.x, $0.y), SIMD2(2 * $0.x + 1, $0.y)] }.flatMap(Array.init))
    var wideBoxes = Set(warehouse.boxes.map { SIMD2( 2 * $0.x, $0.y) })
    var robot = SIMD2(warehouse.robot.x * 2, warehouse.robot.y)
    for instruction in warehouse.instructions {
      if canMove(direction: instruction, point: robot, width: 1, walls: wideWalls, boxes: wideBoxes) {
        robot = moveBoxes(&wideBoxes, direction: instruction, point: robot, width: 1, walls: wideWalls) ?? robot
      }
    }
    return wideBoxes.reduce(0) { $0 + 100 * $1.y + $1.x }
  }
  
  func canMove(direction: Character, point: SIMD2<Int>, width: Int, walls: Set<SIMD2<Int>>, boxes: Set<SIMD2<Int>>) -> Bool {
    let vector: SIMD2<Int>
    switch direction {
    case ">": vector = SIMD2(1,0)
    case "v": vector = SIMD2(0,1)
    case "<": vector = SIMD2(-1,0)
    case "^": vector = SIMD2(0,-1)
    default: return false
    }
    let points = Array(0..<width).map {
      point &+ vector &+ SIMD2($0,0)
    }
    
    guard walls.intersection(points).isEmpty else { return false }
    
    let intersectedBoxes = boxes.filter {
      $0 != point && !Set([$0, $0 &+ SIMD2(1,0)]).intersection(points).isEmpty
    }
    for box in intersectedBoxes {
      if !canMove(direction: direction, point: box, width: 2, walls: walls, boxes: boxes) {
        return false
      }
    }
    
    return true
  }
  
  func moveBoxes(_ boxes: inout Set<SIMD2<Int>>, direction: Character, point: SIMD2<Int>, width: Int, walls: Set<SIMD2<Int>>) -> SIMD2<Int>? {
    let vector: SIMD2<Int>
    switch direction {
    case ">": vector = SIMD2(1,0)
    case "v": vector = SIMD2(0,1)
    case "<": vector = SIMD2(-1,0)
    case "^": vector = SIMD2(0,-1)
    default: return nil
    }
    let points = Array(0..<width).map {
      point &+ vector &+ SIMD2($0,0)
    }
    
    guard walls.intersection(points).isEmpty else { return nil }
    
    let intersectedBoxes = boxes.filter {
      $0 != point && !Set([$0, $0 &+ SIMD2(1,0)]).intersection(points).isEmpty
    }
    for box in intersectedBoxes {
      boxes.remove(box)
      if let movedBox = moveBoxes(&boxes, direction: direction, point: box , width: 2, walls: walls) {
        boxes.insert(movedBox)
      } else {
        boxes.insert(box)
      }
    }
    
    return points[0]
  }
  
  func printMap(width: Int, height: Int, robot: SIMD2<Int>, walls: Set<SIMD2<Int>>, boxes: Set<SIMD2<Int>>) {
    for y in 0..<height {
      var row = ""
      for x in 0..<width {
        let pt = SIMD2(x, y)
        if walls.contains(pt) { row += "#" }
        else if boxes.contains(pt) { row += "O" }
        else if robot == pt { row += "@" }
        else { row += "." }
      }
      print(row)
    }
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
