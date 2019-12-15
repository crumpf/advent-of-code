import Foundation

// https://adventofcode.com/2019/day/3

var str = "Advent of Code 2019, Day 3"
print(str)

let fileURL = URL(fileURLWithPath: "input.txt", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
let fileInput = try String(contentsOf: fileURL, encoding: .utf8)

let wireData = fileInput.components(separatedBy: "\n")

struct GridPoint {
    var x: Int
    var y: Int
}

extension GridPoint: Hashable {
    static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    static func + (lhs: GridPoint, rhs: GridPoint) -> GridPoint {
        return GridPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func += (lhs: inout GridPoint, rhs: GridPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    func manhattanDistance(from: GridPoint) -> Int {
        return abs(x - from.x) + abs(y - from.y)
    }
}

struct Wire {
    let path: [String]

    init(path pathInput: String) {
        path = pathInput.components(separatedBy: ",")
    }

    func getPathPoints() -> (Set<GridPoint>?, [GridPoint : Int]) {
        var points = Set<GridPoint>()
        var location = GridPoint(x: 0, y: 0)
        var stepsToPoint: [GridPoint : Int] = [:]
        var stepCount = 0
        for step in path {
            guard step.count >= 2 else {
                print("error reading path data, step.count < 2")
                return (nil, stepsToPoint)
            }
            let direction = String(step.prefix(1))

            guard let distance = Int(step.suffix(from: String.Index(utf16Offset: 1, in: step))) else {
                print("error reading path data, invalid distance")
                return (nil, stepsToPoint)
            }

            guard let vector = vectorForDirection(direction) else {
                print("error with direction specified: " + direction)
                return (nil, stepsToPoint)
            }

            for _ in 1...distance {
                location += vector
                points.insert(location)

                stepCount += 1
                if stepsToPoint[location] == nil {
                    stepsToPoint[location] = stepCount
                }
            }
        }
        return (points, stepsToPoint)
    }

    private func vectorForDirection(_ direction: String) -> GridPoint? {
        switch direction {
        case "L":
            return GridPoint(x: -1, y: 0)
        case "R":
            return GridPoint(x: 1, y: 0)
        case "U":
            return GridPoint(x: 0, y: 1)
        case "D":
            return GridPoint(x: 0, y: -1)
        default:
            return nil
        }
    }
}

func smallestManhattanDistance(first: Wire, second: Wire) -> Int {
    let (wire1Points, _) = first.getPathPoints()
    let (wire2Points, _) = second.getPathPoints()

    if let wire1Points = wire1Points, let wire2Points = wire2Points {
        let intersections = wire1Points.intersection(wire2Points)

        let origin = GridPoint(x: 0, y: 0)
        var smallest = Int.max
        for i in intersections {
            let md = i.manhattanDistance(from: origin)
            if md < smallest {
                smallest = md
            }
        }
        return smallest
    } else {
        print("error getting path points")
        return 0
    }
}

var md = 0

let test1 = Wire(path: "R75,D30,R83,U83,L12,D49,R71,U7,L72")
let test2 = Wire(path: "U62,R66,U55,R34,D71,R55,D58,R83")
md = smallestManhattanDistance(first: test1, second: test2)
if md == 159 {
    print("test 1 passed")
} else {
    print("test 1 failed")
}

let test3 = Wire(path: "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51")
let test4 = Wire(path: "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
md = smallestManhattanDistance(first: test3, second: test4)
if (md == 135) {
    print("test 2 passed")
} else {
    print("test 2 failed")
}

let wire1 = Wire(path: wireData[0])
let wire2 = Wire(path: wireData[1])
md = smallestManhattanDistance(first: wire1, second: wire2)
print("Manhattan distance to closest intersection: \(md)")
// 721 is correct answer


// PART 2
// https://adventofcode.com/2019/day/3#part2

func closestDistance(first: Wire, second: Wire) -> Int {
    let (w1Points, w1Steps) = first.getPathPoints()
    let (w2Points, w2Steps) = second.getPathPoints()

    if let w1Points = w1Points, let w2Points = w2Points {
        let intersections = w1Points.intersection(w2Points)

        var smallest = Int.max
        for i in intersections {
            guard let d1 = w1Steps[i], let d2 = w2Steps[i] else {
                return 0
            }
            let dist = d1 + d2
            if dist < smallest {
                smallest = dist
            }
        }
        return smallest
    } else {
        print("error getting path points")
        return 0
    }
}

var cd = 0

cd = closestDistance(first: test1, second: test2)
if (cd == 610) {
    print("test 2:1 passed")
} else {
    print("test 2:1 failed")
}

cd = closestDistance(first: test3, second: test4)
if (cd == 410) {
    print("test 2:2 passed")
} else {
    print("test 2:2 failed")
}

cd = closestDistance(first: wire1, second: wire2)
print("closest intersection by steps: \(cd)")
// answer is 7388
