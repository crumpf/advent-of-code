//
//  main.swift
//  Day 10
//
//  Created by Christopher Rumpf on 12/10/20.
//

import Foundation

class Day {
  // separate the input into sequential runs, each run being 3 apart from the next
  func makeRuns(joltages: [Int]) -> [[Int]] {
    var runs: [[Int]] = []
    var run: [Int] = [0] // start with the output joltage
    for joltage in joltages.sorted() {
      let diff = joltage - run.last!
      switch diff {
      case 1:
        run.append(joltage)
      case 3:
        runs.append(run)
        run = [joltage]
      default:
        print("Found a diff other than 1 or 3: \(diff)")
      }
    }
    runs.append(run)
    return runs
  }
}

extension Day: Puzzle {
///  Find a chain that uses all of your adapters to connect the charging outlet to your device's built-in adapter and count the joltage differences between the charging outlet, the adapters, and your device. What is the number of 1-jolt differences multiplied by the number of 3-jolt differences?
  func part1(withInput input: String) -> String {
    let joltages = input.lines().compactMap { Int($0) }.sorted()
    let runs = makeRuns(joltages: joltages)

    // we now have runs: which are arrays that each have some number of joltages that are all 1 apart
    let diffOf1 = runs.reduce(0) { $0 + $1.count } - runs.count
    let diffOf3 = runs.count
    
    return String(diffOf1 * diffOf3)
  }
  
  func part2(withInput input: String) -> String {
    let joltages = input.lines().compactMap { Int($0) }.sorted()
    let runs = makeRuns(joltages: joltages)
    
    // permutations for a run, key:run length, value:perms
    let permMap = [1:1, 2:1, 3:2, 4:4, 5:7] // when debugging, I didn't see any runs > 5, so I'm not accounting for anything bigger
    let perms = runs.reduce(1) { $0 * permMap[$1.count]! } // with this unwrap we'll go down in flames if there's a run I haven't accounted for in my map 😰
    
    return String(perms)
  }
}

let testInput = """
16
10
15
5
1
11
7
19
6
12
4
"""

let testInput2 = """
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
"""

guard let fileInput = FileInput(pathRelativeToCurrentDirectory: "input.txt") else { abort() }

let day = Day()

print("====Test 1====")
let test1 = day.part1(withInput: testInput2)
print(test1)

print("====Test 2====")
let test2 = day.part2(withInput: testInput2)
print(test2)

print("====Part 1====")
let part1 = day.part1(withInput: fileInput.raw)
print(part1)

print("====Part 2====")
let part2 = day.part2(withInput: fileInput.raw)
print(part2)
